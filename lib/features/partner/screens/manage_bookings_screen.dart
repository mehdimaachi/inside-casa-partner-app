// In: lib/features/partner/screens/manage_bookings_screen.dart

import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';

class ManageBookingsScreen extends StatefulWidget {
  // --- UPDATED: It now requires the token to be passed in ---
  final String token;

  const ManageBookingsScreen({
    super.key,
    required this.token,
  });

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;

  Future<void>? _fetchFuture;

  List<Object> _allBookings = [];
  List<Object> _pending = [];
  List<Object> _confirmed = [];
  List<Object> _cancelled = [];

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchFuture = _fetchAndCategorizeBookings();
  }

  Future<void> _fetchAndCategorizeBookings() async {
    // --- THE FIX: Uses passed-in widget.token, no longer reads from storage ---
    try {
      final activityBookingsFuture = _apiService.getActivityReservations(widget.token);
      final restaurantBookingsFuture = _apiService.getRestaurantReservations(widget.token);

      final results = await Future.wait([activityBookingsFuture, restaurantBookingsFuture]);

      final allBookings = [...results[0], ...results[1]];

      if (mounted) {
        setState(() {
          _allBookings = allBookings;
          _pending = _allBookings.where((b) => _getStatus(b) == 'pending').toList();
          _confirmed = _allBookings.where((b) => _getStatus(b) == 'confirmed').toList();
          _cancelled = _allBookings.where((b) => _getStatus(b) == 'cancelled').toList();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  String _getStatus(Object booking) {
    if (booking is Reservation) return booking.status;
    if (booking is RestaurantReservation) return booking.status;
    return '';
  }

  Future<void> _updateStatus(Object booking, String newStatus) async {
    setState(() { _isUpdating = true; });

    try {
      // --- THE FIX: Uses passed-in widget.token ---
      int id = (booking is Reservation) ? booking.id : (booking as RestaurantReservation).id;
      bool isRestaurant = booking is RestaurantReservation;

      await _apiService.updateReservationStatus(widget.token, id, newStatus, isRestaurant: isRestaurant);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking updated to $newStatus')));

      await _fetchAndCategorizeBookings();

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if(mounted) {
        setState(() { _isUpdating = false; });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Bookings"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Pending (${_pending.length})"),
            Tab(text: "Confirmed (${_confirmed.length})"),
            Tab(text: "Cancelled (${_cancelled.length})"),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text("Error fetching bookings.\n\nDetails: ${snapshot.error}", textAlign: TextAlign.center)));
          }

          return AbsorbPointer(
            absorbing: _isUpdating,
            child: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingList(_pending, isPending: true),
                    _buildBookingList(_confirmed),
                    _buildBookingList(_cancelled),
                  ],
                ),
                if (_isUpdating)
                  Container(
                    color: Colors.black.withOpacity(0.1),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List<Object> bookings, {bool isPending = false}) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings in this category.'));
    }
    return RefreshIndicator(
      onRefresh: _fetchAndCategorizeBookings,
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking, isPending: isPending);
        },
      ),
    );
  }

  Widget _buildBookingCard(Object booking, {bool isPending = false}) {
    String title, subtitle;

    if (booking is Reservation) {
      title = 'Activity Booking #${booking.id}';
      subtitle = '${booking.participants} participants';
    } else if (booking is RestaurantReservation) {
      title = 'Restaurant Booking #${booking.id}';
      subtitle = '${booking.guests} guests on ${booking.reservationDate.toLocal().toString().split(' ')[0]}';
    } else {
      return const SizedBox.shrink();
    }

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