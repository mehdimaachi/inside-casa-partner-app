// In: lib/features/partner/models/restaurant.dart

class Restaurant {
  final int id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String email;
  final String? website;
  final List<String> imageUrls;
  final bool isActive;
  final int categoryId;
  final int partnerId;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.email,
    this.website,
    required this.imageUrls,
    required this.isActive,
    required this.categoryId,
    required this.partnerId,
  });

// In: lib/features/partner/models/restaurant.dart

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      // THE FIX: Parse from a string to a double.
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      imageUrls: List<String>.from(json['image_urls']),
      isActive: json['is_active'],
      categoryId: json['category_id'],
      partnerId: json['partner_id'],
    );
  }
}