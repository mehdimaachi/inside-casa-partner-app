// Fichier: lib/features/partner/models/restaurant.dart
class Restaurant {
  final int? id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final double rating;
  final String category;
  final String price_range;
  final String opening_hours;
  final String image_url;
  final int partner_id;

  Restaurant({
    this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    this.rating = 0.0,
    required this.category,
    required this.price_range,
    required this.opening_hours,
    required this.image_url,
    required this.partner_id,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'] ?? 'Restaurant sans nom',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) ?? 0.0 : 0.0,
      category: json['category'] ?? '',
      price_range: json['price_range'] ?? '',
      opening_hours: json['opening_hours'] ?? '',
      image_url: json['image_url'] ?? '',
      partner_id: json['partner_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'rating': rating,
      'category': category,
      'price_range': price_range,
      'opening_hours': opening_hours,
      'image_url': image_url,
      'partner_id': partner_id,
    };
  }
}