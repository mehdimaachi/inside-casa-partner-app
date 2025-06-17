// In: lib/features/partner/screens/manage_listings_screen.dart

import 'package:flutter/material.dart';
import 'package:inside_casa_app/theme/AppTheme.dart'; // Import for colors
import 'activity_form_screen.dart';
import '../services/api_service.dart';
import '../models/activity.dart';
import '../models/restaurant.dart';
import '../models/user.dart';

class ManageListingsScreen extends StatefulWidget {
  // --- UPDATED: It now requires the partner and token to be passed in ---
  final PartnerUser partner;
  final String token;

  const ManageListingsScreen({
    super.key,
    required this.partner,
    required this.token,
  });

  @override
  State<ManageListingsScreen> createState() => _ManageListingsScreenState();
}

class _ManageListingsScreenState extends State<ManageListingsScreen> {
  final ApiService _apiService = ApiService();
  Future<List<Object>>? _listingsFuture;

  @override
  void initState() {
    super.initState();
    _listingsFuture = _fetchListings();
  }

  Future<List<Object>> _fetchListings() async {
    // --- THE FIX: Uses passed-in widget data, no longer reads from storage ---
    try {
      final activitiesFuture = _apiService.getActivitiesForPartner(
        partnerId: widget.partner.id,
        token: widget.token,
      );
      final restaurantsFuture = _apiService.getRestaurantsForPartner(
        partnerId: widget.partner.id,
        token: widget.token,
      );
      final results = await Future.wait([activitiesFuture, restaurantsFuture]);
      return [...results[0] as List<Activity>, ...results[1] as List<Restaurant>];
    } catch (e) {
      // Re-throw the error so the FutureBuilder can display it
      throw Exception(e);
    }
  }

  // --- UPDATED: This navigation method now uses passed-in widget data ---
  void _navigateToForm({Activity? activityToEdit}) async {
    // We await the result. The form screen will pop 'true' on a successful save.
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityFormScreen(
          authToken: widget.token,
          partnerId: widget.partner.id,
          activityToEdit: activityToEdit,
        ),
      ),
    );

    // If the form was saved successfully, refresh the list.
    if (shouldRefresh == true) {
      setState(() {
        _listingsFuture = _fetchListings();
      });
    }
  }

  // --- UPDATED: The delete function now uses passed-in widget data ---
  Future<void> _deleteListing(Object item) async {
    try {
      final int id = (item is Activity) ? item.id! : (item as Restaurant).id;
      final bool isRestaurant = item is Restaurant;
      final String itemName = (item is Activity) ? item.title : (item as Restaurant).name;

      await _apiService.deleteListing(widget.token, id, isRestaurant: isRestaurant);

      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$itemName" was deleted successfully.'), backgroundColor: Colors.green),
      );
      setState(() { _listingsFuture = _fetchListings(); });

    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red),
      );
    }
  }

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
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(ctx).pop();
                _deleteListing(item);
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text("Error: ${snapshot.error}", textAlign: TextAlign.center)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("You haven't created any listings yet."));
          }
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
                    onEdit: () => _navigateToForm(activityToEdit: item),
                    onDelete: () => _showDeleteConfirmation(item),
                  );
                }
                if (item is Restaurant) {
                  return _buildListingCard(
                    icon: Icons.restaurant,
                    title: item.name,
                    subtitle: "Restaurant: ${item.address}",
                    onEdit: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Editing restaurants is not yet implemented.")));
                    },
                    onDelete: () => _showDeleteConfirmation(item),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Add Listing',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}