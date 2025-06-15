// In: lib/features/partner/screens/partner_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'manage_listings_screen.dart';
import 'manage_bookings_screen.dart';
import 'view_statistics_screen.dart';
import '../models/user.dart'; // We need the user model
import '../services/api_service.dart'; // And the api service

class PartnerDashboardScreen extends StatefulWidget {
  // The dashboard now requires the logged-in partner's info
  final PartnerUser partner;

  const PartnerDashboardScreen({super.key, required this.partner});

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  int _totalListings = 0;
  int _pendingBookings = 0;
  // We can add more stats here, like reviews, revenue, etc.

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() { _isLoading = true; });

    try {
      // In a real scenario, you'd get the token from secure storage
      const String fakeToken = 'fake-jwt-token-for-testing';

      // We will fetch multiple pieces of data in parallel
      final listingsFuture = _apiService.getActivitiesForPartner(partnerId: widget.partner.id, token: fakeToken);
      final bookingsFuture = _apiService.getActivityReservations(fakeToken);

      final results = await Future.wait([listingsFuture, bookingsFuture]);

      final listings = results[0] as List;
      final bookings = results[1] as List;

      setState(() {
        _totalListings = listings.length;
        // Filter bookings to find only the pending ones
        _pendingBookings = bookings.where((b) => b.status == 'pending').length;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.partner.fullname}"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchDashboardData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: <Widget>[
              _buildDashboardCard(
                context: context,
                icon: Icons.store,
                label: 'Manage Listings',
                // Display the stat we fetched
                stat: '$_totalListings listings',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageListingsScreen()));
                },
              ),
              _buildDashboardCard(
                context: context,
                icon: Icons.calendar_today,
                label: 'Manage Bookings',
                stat: '$_pendingBookings pending',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageBookingsScreen()));
                },
              ),
              _buildDashboardCard(
                context: context,
                icon: Icons.bar_chart,
                label: 'View Statistics',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewStatisticsScreen()));
                },
              ),
              _buildDashboardCard(
                context: context,
                icon: Icons.reviews,
                label: 'Manage Reviews',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget updated to show stats
  Widget _buildDashboardCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    String? stat,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (stat != null) ...[
              const SizedBox(height: 8),
              Text(
                stat,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ]
          ],
        ),
      ),
    );
  }
}