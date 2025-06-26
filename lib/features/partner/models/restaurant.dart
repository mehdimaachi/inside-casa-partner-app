// In: lib/features/partner/models/restaurant.dart

class Restaurant {
  final int id;
  final String name;
  final String address;
  final String phone;
  final bool isPromoted;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.isPromoted = false,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      // On s'assure que même si l'ID est null, on ne fait pas planter l'app
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name Provided',
      address: json['address'] ?? 'No Address Provided',
      phone: json['phone'] ?? 'No Phone Provided',
      isPromoted: json['is_promoted'] ?? false,
    );
  }
}