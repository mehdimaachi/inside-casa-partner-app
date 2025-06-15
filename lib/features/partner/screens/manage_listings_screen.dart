// In: lib/features/partner/screens/manage_listings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'add_activity_screen.dart';
import '../services/api_service.dart';
import '../models/activity.dart';
import '../models/restaurant.dart';

class ManageListingsScreen extends StatefulWidget {
  const ManageListingsScreen({super.key});

  @override
  State<ManageListingsScreen> createState() => _ManageListingsScreenState();
}

class _ManageListingsScreenState extends State<ManageListingsScreen> {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();
  Future<List<Object>>? _listingsFuture;

  @override
  void initState() {
    super.initState();
    _listingsFuture = _fetchListings();
  }

  Future<List<Object>> _fetchListings() async {
    // ... (This function remains the same as before)
    final token = await _storage.read(key: 'auth_token');
    final partnerIdString = await _storage.read(key: 'partner_id');
    if (token == null || partnerIdString == null) {
      throw Exception("Authentication details not found.");
    }
    final partnerId = int.parse(partnerIdString);
    final activitiesFuture = _apiService.getActivitiesForPartner(partnerId: partnerId, token: token);
    final restaurantsFuture = _apiService.getRestaurantsForPartner(partnerId: partnerId, token: token);
    final results = await Future.wait([activitiesFuture, restaurantsFuture]);
    return [...results[0] as List<Activity>, ...results[1] as List<Restaurant>];
  }

  void _navigateAndRefresh() async {
    // ... (This function remains the same as before)
    final token = await _storage.read(key: 'auth_token');
    final partnerIdString = await _storage.read(key: 'partner_id');
    if (token == null || partnerIdString == null) return;
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddActivityScreen(authToken: token, partnerId: int.parse(partnerIdString),),),);
    if (result == true) {
      setState(() { _listingsFuture = _fetchListings(); });
    }
  }

  // --- NEW: Method to handle the delete action ---
  Future<void> _deleteListing(Object item) async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) throw Exception("Auth token not found.");

      final int id = (item is Activity) ? item.id! : (item as Restaurant).id;
      final bool isRestaurant = item is Restaurant;
      final String itemName = (item is Activity) ? item.title : (item as Restaurant).name;

      await _apiService.deleteListing(token, id, isRestaurant: isRestaurant);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$itemName" was deleted successfully.'), backgroundColor: Colors.green),
      );

      // Refresh the list
      setState(() {
        _listingsFuture = _fetchListings();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // --- NEW: Method to show the confirmation dialog ---
  void _showDeleteConfirmation(Object item) {
    final String itemName = (item is Activity) ? item.title : (item as Restaurant).name;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to permanently delete "$itemName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(), // Close the dialog
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                _deleteListing(item); // Call the delete function
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Your Listings")),
      body: FutureBuilder<List<Object>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          // ... (The FutureBuilder logic for loading, error, and no data is the same)
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text("Error: ${snapshot.error}", textAlign: TextAlign.center)));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("You haven't created any listings yet."));

          final listings = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async { setState(() { _listingsFuture = _fetchListings(); }); },
            child: ListView.builder(
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];
                if (item is Activity) {
                  return _buildListingCard(
                    icon: Icons.directions_walk,
                    title: item.title,
                    subtitle: "Activity: ${item.price} MAD",
                    onDelete: () => _showDeleteConfirmation(item), // --- UPDATED ---
                  );
                }
                if (item is Restaurant) {
                  return _buildListingCard(
                    icon: Icons.restaurant,
                    title: item.name,
                    subtitle: "Restaurant: ${item.address}",
                    onDelete: () => _showDeleteConfirmation(item), // --- UPDATED ---
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _navigateAndRefresh, tooltip: 'Add Listing', child: const Icon(Icons.add)),
    );
  }

  // --- UPDATED to accept an onDelete callback ---
  Widget _buildListingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}