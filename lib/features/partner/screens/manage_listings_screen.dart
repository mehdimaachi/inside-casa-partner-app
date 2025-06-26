import 'package:flutter/material.dart';
import 'package:inside_casa_app/theme/AppTheme.dart'; // Import for colors
import 'activity_form_screen.dart';
import '../services/api_service.dart';
import '../models/activity.dart';
import '../models/restaurant.dart';
import '../models/user.dart';

class ManageListingsScreen extends StatefulWidget {
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
  // On utilise des Futures séparés pour chaque type de données
  late Future<List<Activity>> _activitiesFuture;
  late Future<List<Restaurant>> _restaurantsFuture;
  final Map<int, bool> _isTogglingPromotion = {};

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  void _fetchListings() {
    setState(() {
      _activitiesFuture = _apiService.getActivitiesForPartner(
          partnerId: widget.partner.id, token: widget.token);
      _restaurantsFuture = _apiService.getRestaurantsForPartner(
          partnerId: widget.partner.id, token: widget.token);
    });
  }

  void _navigateToForm({Activity? activityToEdit}) async {
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
    if (shouldRefresh == true) {
      _fetchListings();
    }
  }

  Future<void> _deleteListing(dynamic item) async {
    try {
      final int id = (item is Activity) ? item.id! : (item as Restaurant).id;
      final bool isRestaurant = item is Restaurant;
      await _apiService.deleteListing(widget.token, id, isRestaurant: isRestaurant);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Listing deleted successfully.'), backgroundColor: Colors.green),
      );
      _fetchListings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showDeleteConfirmation(dynamic item) {
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

  Future<void> _togglePromotion(dynamic item) async {
    final int id = item.id!;
    setState(() => _isTogglingPromotion[id] = true);

    try {
      await _apiService.togglePromotionStatus(widget.token, id);
      _fetchListings(); // Rafraîchit les données pour mettre à jour l'UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update promotion: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isTogglingPromotion.remove(id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Your Listings")),
      body: FutureBuilder(
        future: Future.wait([_activitiesFuture, _restaurantsFuture]),
        builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching listings: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No listings found."));
          }

          // On caste explicitement les résultats pour garantir la sécurité des types
          final List<Activity> activities = snapshot.data![0].cast<Activity>();
          final List<Restaurant> restaurants = snapshot.data![1].cast<Restaurant>();
          final List<dynamic> combinedList = [...activities, ...restaurants];

          if (combinedList.isEmpty) {
            return const Center(child: Text("You haven't created any listings yet."));
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchListings(),
            child: ListView.builder(
              itemCount: combinedList.length,
              itemBuilder: (context, index) {
                final item = combinedList[index];
                return _buildListingCard(item);
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

  Widget _buildListingCard(dynamic item) {
    final isActivity = item is Activity;
    final id = item.id!;
    final title = isActivity ? item.title : (item as Restaurant).name;
    final subtitle = isActivity ? "Activity: ${item.price} MAD" : "Restaurant: ${item.address}";
    final icon = isActivity ? Icons.directions_walk : Icons.restaurant;
    final isPromoted = item.isPromoted ?? false;
    final isToggling = _isTogglingPromotion[id] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryBlue),
        title: Row(
          children: [
            if (isPromoted) const Icon(Icons.star, color: Colors.amber, size: 20),
            if (isPromoted) const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isToggling)
              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Switch(
                value: isPromoted,
                onChanged: (value) => _togglePromotion(item),
                activeTrackColor: Colors.amber.withOpacity(0.5),
                activeColor: Colors.amber,
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => isActivity ? _navigateToForm(activityToEdit: item) : null,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(item),
            ),
          ],
        ),
      ),
    );
  }
}