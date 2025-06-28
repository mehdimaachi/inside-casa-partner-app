import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'manage_listings_screen.dart';
import 'manage_bookings_screen.dart';
import 'view_statistics_screen.dart';
import 'manage_reviews_screen.dart';
import '../models/user.dart';
import '../models/activity.dart';
import '../models/restaurant.dart';
import '../models/reservation.dart';
import '../services/mock_service.dart'; // Updated to use MockService
import '../../../theme/AppTheme.dart';
import './partner_profile_screen.dart';

class PartnerDashboardScreen extends StatefulWidget {
  static const routeName = '/partner-dashboard';
  final PartnerUser user;
  final String token;

  const PartnerDashboardScreen({
    super.key,
    required this.user,
    required this.token,
  });

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  bool _isLoading = true;
  int _totalListings = 0;
  int _pendingBookings = 0;

  final MockService _mockService = MockService(); // Use MockService for data

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    List<Activity> activities = [];
    List<Restaurant> restaurants = [];
    List<Reservation> allBookings = [];
    int totalListings = 0;

    // Step 1: Load listings
    try {
      final listingResults = await Future.wait([
        _mockService.getPartnerActivities(),
        _mockService.getPartnerRestaurants(),
      ]);

      activities = listingResults[0] as List<Activity>;
      restaurants = listingResults[1] as List<Restaurant>;
      totalListings = activities.length + restaurants.length;

      print("Activities count: ${activities.length}");
      print("Restaurants count: ${restaurants.length}");
      print("Total listings: $totalListings");
    } catch (e) {
      print("Error loading listings: $e");
    }

    // Step 2: Load reservations
    try {
      allBookings = await _mockService.getPartnerReservations();
      print("Reservations count: ${allBookings.length}");
    } catch (e) {
      print("Error loading reservations: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Couldn't load booking data."),
          backgroundColor: Colors.orange,
        ));
      }
    }

    // Step 3: Update UI
    if (mounted) {
      setState(() {
        _totalListings = totalListings; // Update total listings correctly
        _pendingBookings = allBookings.where((b) => b.status.toLowerCase() == 'pending').length;
        _isLoading = false;
      });

      print("_totalListings updated to: $_totalListings");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.user.fullname}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'My Profile',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PartnerProfileScreen(),
                  settings: RouteSettings(arguments: {'user': widget.user, 'token': widget.token}),
                ),
              );
            },
          ),
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchDashboardData,
            )
        ],
      ),
      body: _isLoading ? _buildLoadingSkeleton() : _buildDashboardGrid(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: List.generate(4, (index) => _buildSkeletonCard()),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildDashboardGrid() {
    return RefreshIndicator(
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
              stat: '18 listings',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ManageListingsScreen(
                      partner: widget.user,
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
                    builder: (context) => const ManageBookingsScreen()
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageReviewsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

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