// In: lib/features/partner/screens/partner_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'manage_listings_screen.dart';
import 'manage_bookings_screen.dart';
import 'view_statistics_screen.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../models/reservation.dart';
import '../../../theme/AppTheme.dart'; // Import theme for colors

class PartnerDashboardScreen extends StatefulWidget {
  final PartnerUser partner;
  final String token;

  const PartnerDashboardScreen({
    super.key,
    required this.partner,
    required this.token,
  });

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  int _totalListings = 0;
  int _pendingBookings = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });

    try {
      final listingsFuture = _apiService.getActivitiesForPartner(partnerId: widget.partner.id, token: widget.token);
      final restaurantsFuture = _apiService.getRestaurantsForPartner(partnerId: widget.partner.id, token: widget.token);
      final bookingsFuture = _apiService.getActivityReservations(widget.token);
      final restaurantBookingsFuture = _apiService.getRestaurantReservations(widget.token);

      final results = await Future.wait([listingsFuture, restaurantsFuture, bookingsFuture, restaurantBookingsFuture]);

      final activities = results[0] as List;
      final restaurants = results[1] as List;
      final activityBookings = results[2] as List<Reservation>;
      final restaurantBookings = results[3] as List<RestaurantReservation>;

      if (mounted) {
        setState(() {
          _totalListings = activities.length + restaurants.length;
          final pendingActivityBookings = activityBookings.where((b) => b.status == 'pending').length;
          final pendingRestaurantBookings = restaurantBookings.where((b) => b.status == 'pending').length;
          _pendingBookings = pendingActivityBookings + pendingRestaurantBookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching dashboard data: $e"), backgroundColor: Colors.red));
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.partner.fullname}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDashboardData,
          )
        ],
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
                stat: '$_totalListings listings',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ManageListingsScreen(
                        partner: widget.partner,
                        token: widget.token,
                      )
                  ));
                },
              ),
              _buildDashboardCard(
                context: context,
                icon: Icons.calendar_today,
                label: 'Manage Bookings',
                stat: '$_pendingBookings pending',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ManageBookingsScreen(
                        token: widget.token,
                      )
                  ));
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
                onTap: () { /* TODO: Navigate to ManageReviewsScreen */ },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- THIS IS THE CORRECTED HELPER METHOD ---
  // It always returns a Card widget, so it will not cause a null return error.
  Widget _buildDashboardCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    String? stat,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: AppTheme.primaryBlue),
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