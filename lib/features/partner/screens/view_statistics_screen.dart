// In: lib/features/partner/screens/view_statistics_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/partner_stats.dart';
import '../services/api_service.dart';
import '../../../theme/AppTheme.dart';

class ViewStatisticsScreen extends StatefulWidget {
  const ViewStatisticsScreen({super.key});

  @override
  State<ViewStatisticsScreen> createState() => _ViewStatisticsScreenState();
}

class _ViewStatisticsScreenState extends State<ViewStatisticsScreen> {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();
  Future<PartnerStats>? _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _fetchStats();
  }

  Future<PartnerStats> _fetchStats() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception("Token not found");
    return _apiService.getPartnerStats(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Performance Statistics"),
      ),
      body: FutureBuilder<PartnerStats>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Could not load stats.\n(This is expected if the backend endpoint doesn't exist yet)\n\nError: ${snapshot.error}", textAlign: TextAlign.center),
            ));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No statistics available."));
          }

          final stats = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _statsFuture = _fetchStats();
              });
            },
            // --- THIS IS THE CORRECTED SECTION ---
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCards(stats),
                  const SizedBox(height: 24),
                  const Text("Bookings per Month", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildBarChart(stats.bookingsPerMonth),
                  const SizedBox(height: 24),
                  const Text("Top Performing Listings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTopListings(stats.topListings),
                ],
              ),
            ), // The extra "Of)" has been removed here
          );
        },
      ),
    );
  }

  Widget _buildStatCards(PartnerStats stats) {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Total Revenue", style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text("${stats.totalRevenue.toStringAsFixed(2)} MAD", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Total Bookings", style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text(stats.totalBookings.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<MonthlyBooking> data) {
    if (data.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("No monthly data available.")));
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final monthlyData = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthlyData.count.toDouble(),
                  color: AppTheme.primaryBlue,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4,
                      child: Text(data[value.toInt()].month, style: style),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  Widget _buildTopListings(List<ListingPerformance> data) {
    if (data.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("No listing performance data available.")));
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final listing = data[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(listing.title),
            trailing: Text("${listing.bookingCount} bookings", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}