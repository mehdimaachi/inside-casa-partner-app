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
  final bool isActive;
  final List<String> imageUrls;
  final int categoryId;
  final int partnerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool isPromoted;


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
    this.isPromoted = false, // Valeur par défaut
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    double safeParseDouble(dynamic value) {
      if (value == null) return 0.0;
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return Activity(
      id: json['id'],
      title: json['title'] ?? 'No Title Provided',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      latitude: safeParseDouble(json['latitude']),
      longitude: safeParseDouble(json['longitude']),
      price: safeParseDouble(json['price']),
      duration: safeParseInt(json['duration']),
      categoryId: safeParseInt(json['category_id']),
      partnerId: safeParseInt(json['partner_id']),
      isActive: json['is_active'] ?? false,
      isPromoted: json['is_promoted'] ?? false,
      imageUrls: json['image_urls'] != null ? List<String>.from(json['image_urls']) : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
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
      'is_promoted': isPromoted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}