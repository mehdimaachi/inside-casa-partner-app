import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
import '../services/mock_service.dart'; // Importation du service mock
import 'package:shimmer/shimmer.dart'; // Pour l'effet de chargement
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({Key? key}) : super(key: key);

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();
  final MockService _mockService = MockService(); // Service mock pour les données de secours

  late TabController _tabController;

  List<Reservation> allReservations = [];
  bool isLoading = true;
  String? error;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Essayer d'abord l'API réelle
      try {
        final apiReservations = await _apiService.getPartnerReservations();
        setState(() {
          allReservations = apiReservations;
          isLoading = false;
        });
      } catch (apiError) {
        print("API Error: $apiError");
        // En cas d'échec, utiliser les données mock
        final mockReservations = await _mockService.getPartnerReservations();
        setState(() {
          allReservations = mockReservations;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _updateReservationStatus(int reservationId, String newStatus) async {
    setState(() { _isUpdating = true; });

    try {
      bool success = false;

      // Essayer d'abord l'API réelle
      try {
        final token = await _secureStorage.read(key: 'jwt_token');
        success = await _apiService.updateReservationStatus(
          token ?? '', // Token
          reservationId,  // ID de réservation
          newStatus,     // Nouveau statut
        );
      } catch (apiError) {
        // En cas d'échec, utiliser le service mock
        success = await _mockService.updateReservationStatus(
            reservationId,  // ID de réservation
            newStatus       // Nouveau statut
        );
      }

      if (success) {
        // Mise à jour locale de la réservation
        setState(() {
          allReservations = allReservations.map((reservation) {
            if (reservation.id == reservationId) {
              // Créer une copie avec le nouveau statut
              return Reservation(
                id: reservation.id,
                status: newStatus,
                reservationDate: reservation.reservationDate,
                participants: reservation.participants,
                type: reservation.type,
                activity: reservation.activity,
                restaurant: reservation.restaurant,
                user: reservation.user,
                totalPrice: reservation.totalPrice,
              );
            }
            return reservation;
          }).toList();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Réservation mise à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de la mise à jour de la réservation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() { _isUpdating = false; });
    }
  }

  // Formatage de date personnalisé sans le package intl
  String _formatDate(DateTime date) {
    // Format: JJ/MM/AAAA à HH:MM
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à $hour:$minute';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les réservations par statut
    final pendingReservations = allReservations.where((r) => r.status == 'pending').toList();
    final confirmedReservations = allReservations.where((r) => r.status == 'confirmed').toList();
    final cancelledReservations = allReservations.where((r) => r.status == 'cancelled').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'En attente (${pendingReservations.length})'),
            Tab(text: 'Confirmées (${confirmedReservations.length})'),
            Tab(text: 'Annulées (${cancelledReservations.length})'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isLoading ? null : _loadReservations,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingShimmer()
          : error != null
          ? _buildErrorView()
          : Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildReservationList(pendingReservations, true),
              _buildReservationList(confirmedReservations, false),
              _buildReservationList(cancelledReservations, false),
            ],
          ),
          if (_isUpdating)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // Widget pour l'effet de chargement
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 100,
                              height: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 12,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 80,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 80,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget pour afficher une erreur
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Erreur lors du chargement des réservations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              error ?? 'Une erreur inconnue est survenue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadReservations,
            icon: Icon(Icons.refresh),
            label: Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher une liste de réservations
  Widget _buildReservationList(List<Reservation> reservations, bool isPending) {
    if (reservations.isEmpty) {
      return Center(
        child: Text(
          isPending
              ? 'Aucune réservation en attente'
              : isPending == false && _tabController.index == 1
              ? 'Aucune réservation confirmée'
              : 'Aucune réservation annulée',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReservations,
      child: ListView.builder(
        itemCount: reservations.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return _buildReservationCard(reservation, isPending);
        },
      ),
    );
  }

  // Widget pour afficher une carte de réservation
  Widget _buildReservationCard(Reservation reservation, bool isPending) {
    // Formatage de la date
    DateTime reservationDate;
    try {
      reservationDate = DateTime.parse(reservation.reservationDate);
    } catch (e) {
      reservationDate = DateTime.now();
    }

    final formattedDate = _formatDate(reservationDate);
    final isActivity = reservation.type == 'activity';

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section utilisateur
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    reservation.user.fullname.isNotEmpty
                        ? reservation.user.fullname[0].toUpperCase()
                        : '?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.user.fullname,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${reservation.participants} personne(s) • ${reservation.price.toStringAsFixed(2)} MAD',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 24),

            // Section détails de l'activité
            Text(
              reservation.listingName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isActivity ? Icons.event : Icons.restaurant,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),

            // Actions pour les réservations en attente
            if (isPending) ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _updateReservationStatus(reservation.id, 'cancelled'),
                    child: Text('Refuser'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _updateReservationStatus(reservation.id, 'confirmed'),
                    child: Text('Confirmer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],

            // Action pour les réservations confirmées
            if (!isPending && reservation.status == 'confirmed') ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _updateReservationStatus(reservation.id, 'cancelled'),
                    child: Text('Annuler'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}