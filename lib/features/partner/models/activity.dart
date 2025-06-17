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
  // In: lib/features/partner/models/activity.dart

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      // THE FIX: We parse the value from a string to a double.
      // We use .toString() first as a safety measure in case the API sometimes sends a number.
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      price: double.parse(json['price'].toString()),
      duration: json['duration'],
      isActive: json['is_active'],
      imageUrls: List<String>.from(json['image_urls']),
      categoryId: json['category_id'],
      partnerId: json['partner_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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