// In: lib/features/partner/models/activity.dart

class Activity {
  final int? id;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final double price;
  final int duration;
  final bool isActive; // Added from API spec
  final List<String> imageUrls;
  final int categoryId;
  final int partnerId;
  final DateTime? createdAt; // Added from API spec
  final DateTime? updatedAt; // Added from API spec

  Activity({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.duration,
    required this.isActive,
    required this.imageUrls,
    required this.categoryId,
    required this.partnerId,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor to create an Activity from a JSON map from the API.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      // This pattern handles both int and double values from JSON safely.
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
      isActive: json['is_active'] as bool,
      // Simplified the list parsing.
      imageUrls: List<String>.from(json['image_urls']),
      categoryId: json['category_id'] as int,
      partnerId: json['partner_id'] as int,
      // Parse string dates into DateTime objects. It's safer to use tryParse.
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  /// Method to convert an Activity instance to a JSON map.
  /// This is essential for sending data to the server (e.g., POST, PUT requests).
  Map<String, dynamic> toJson() {
    return {
      // We don't include the id if it's null (when creating a new activity).
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
      'duration': duration,
      'is_active': isActive,
      'image_urls': imageUrls,
      'category_id': categoryId,
      'partner_id': partnerId,
      // We don't send timestamps to the server; the server sets them.
    };
  }
}