import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class ManageBookingsScreen extends StatefulWidget {
  final String token;
  final PartnerUser partner;

  const ManageBookingsScreen({
    Key? key,
    required this.token,
    required this.partner,
  }) : super(key: key);

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  TabController? _tabController; // Le TabController est maintenant nullable

  late Future<List<Reservation>> _fetchFuture;

  // Plus besoin de listes séparées dans l'état, elles seront générées à la volée
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // On ne crée le TabController que lorsque les données sont prêtes
    _fetchFuture = _fetchBookings();
  }

  Future<List<Reservation>> _fetchBookings() {
    return _apiService.getBookingsForPartner(
      partnerId: widget.partner.id,
      token: widget.token,
    );
  }

  Future<void> _updateStatus(Reservation booking, String newStatus) async {
    setState(() { _isUpdating = true; });
    try {
      await _apiService.updateReservationStatus(
        widget.token,
        booking.id,
        newStatus,
        isRestaurant: booking.type == 'restaurant',
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking updated to $newStatus')));
      // On relance simplement le fetch pour rafraîchir les données
      setState(() {
        _fetchFuture = _fetchBookings();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() { _isUpdating = false; });
    }
  }

  @override
  void dispose() {
    // On s'assure que le controller est disposé s'il a été créé
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      future: _fetchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Manage Bookings")),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Manage Bookings")),
            body: Center(child: Text("Error fetching bookings: ${snapshot.error}")),
          );
        }

        // Les données sont chargées avec succès
        final allBookings = snapshot.data ?? [];
        final pending = allBookings.where((b) => b.status == 'pending').toList();
        final confirmed = allBookings.where((b) => b.status == 'confirmed').toList();
        final cancelled = allBookings.where((b) => b.status == 'cancelled').toList();

        // On initialise le TabController ici, avec le State du Builder
        _tabController ??= TabController(length: 3, vsync: this);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Manage Bookings"),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Pending (${pending.length})"),
                Tab(text: "Confirmed (${confirmed.length})"),
                Tab(text: "Cancelled (${cancelled.length})"),
              ],
            ),
          ),
          body: AbsorbPointer(
            absorbing: _isUpdating,
            child: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingList(pending, isPending: true),
                    _buildBookingList(confirmed),
                    _buildBookingList(cancelled),
                  ],
                ),
                if (_isUpdating)
                  Container(
                    color: Colors.black.withOpacity(0.1),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingList(List<Reservation> bookings, {bool isPending = false}) {
    if (bookings.isEmpty) {
      return RefreshIndicator(
          onRefresh: () async => setState(() { _fetchFuture = _fetchBookings(); }),
          child: ListView( // Utiliser un ListView pour que le RefreshIndicator fonctionne toujours
            children: const [
              SizedBox(height: 100),
              Center(child: Text('No bookings in this category.')),
            ],
          )
      );
    }
    return RefreshIndicator(
      onRefresh: () async => setState(() { _fetchFuture = _fetchBookings(); }),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking, isPending: isPending);
        },
      ),
    );
  }

  Widget _buildBookingCard(Reservation booking, {bool isPending = false}) {
    String title = 'Booking #${booking.id}';
    String subtitle = 'For: ${booking.activity?.title ?? 'N/A'}\nCustomer: ${booking.user.fullname}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isPending
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => _updateStatus(booking, 'confirmed')),
            IconButton(icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () => _updateStatus(booking, 'cancelled')),
          ],
        )
            : null,
      ),
    );
  }
}