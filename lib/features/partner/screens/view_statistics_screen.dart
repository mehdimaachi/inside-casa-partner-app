import 'package:flutter/material.dart';
import '../models/partner_stats.dart';
import '../services/api_service.dart';
import '../services/mock_service.dart';
import 'package:shimmer/shimmer.dart';

class ViewStatisticsScreen extends StatefulWidget {
  static const routeName = '/view-statistics';

  const ViewStatisticsScreen({Key? key}) : super(key: key);

  @override
  State<ViewStatisticsScreen> createState() => _ViewStatisticsScreenState();
}

class _ViewStatisticsScreenState extends State<ViewStatisticsScreen> {
  final ApiService _apiService = ApiService();
  final MockService _mockService = MockService();

  PartnerStats? stats;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Directly use mock data as the real API is unavailable
      final mockStats = await _mockService.getPartnerStatistics();
      setState(() {
        stats = mockStats;
        isLoading = false;
      });
    } catch (mockError) {
      print("Mock Service Error: $mockError");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Statistics'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isLoading ? null : _loadStatistics,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingShimmer()
          : error != null
          ? _buildErrorView()
          : stats == null
          ? _buildEmptyView()
          : RefreshIndicator(
        onRefresh: _loadStatistics,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Summary Cards ---
              _buildStatCard(
                context: context,
                icon: Icons.attach_money,
                label: 'Total Revenue',
                value: '\$ ${stats!.totalRevenue.toStringAsFixed(2)}',
                color: Colors.green.shade600,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                context: context,
                icon: Icons.calendar_today,
                label: 'Total Bookings',
                value: '${stats!.totalBookings}',
                color: Colors.blue.shade600,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                context: context,
                icon: Icons.star_outline_rounded,
                label: 'Average Rating',
                value: '${stats!.averageRating.toStringAsFixed(1)} / 5.0',
                color: Colors.orange.shade600,
              ),
              const SizedBox(height: 32),

              // --- Chart Section ---
              Text(
                'Monthly Bookings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20, thickness: 1),
              const SizedBox(height: 10),
              stats!.monthlyBookings.isEmpty
                  ? _buildEmptyChartView()
                  : _buildMonthlyBookingsChart(stats!.monthlyBookings),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour l'effet de chargement
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cartes de statistiques en mode chargement
            for (var i = 0; i < 3; i++) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Section du graphique en mode chargement
            Container(
              width: 200,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 10),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
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
            'Erreur lors du chargement des statistiques',
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
            onPressed: _loadStatistics,
            icon: Icon(Icons.refresh),
            label: Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher un état vide
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            color: Colors.grey[400],
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Aucune statistique disponible',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Les données statistiques apparaîtront ici',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadStatistics,
            icon: Icon(Icons.refresh),
            label: Text('Actualiser'),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher un graphique vide
  Widget _buildEmptyChartView() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Monthly bookings chart will be displayed here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher le graphique des réservations mensuelles
  Widget _buildMonthlyBookingsChart(List<MonthlyData> monthlyData) {
    // Trouver la valeur maximale pour l'échelle
    final maxValue = monthlyData.fold<int>(0, (max, item) => item.value > max ? item.value : max);
    final chartHeight = 220.0;

    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphique à barres
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthlyData.map((data) {
                // Calculer la hauteur de la barre en fonction de la valeur maximale
                final barHeight = maxValue > 0
                    ? (data.value / maxValue) * chartHeight
                    : 0.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Valeur au-dessus de la barre
                        Text(
                          '${data.value}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // La barre elle-même
                        Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Étiquettes des mois en bas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: monthlyData.map((data) {
              return Text(
                data.getDisplayMonth(),
                style: TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget pour construire les cartes de statistiques
  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}