// In: lib/features/partner/models/user.dart

class PartnerUser {
  final int id;
  final String fullname;
  final String email;
  final String phone;
  final String role; // 'admin'|'customer'|'partner'
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  PartnerUser({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.role,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PartnerUser.fromJson(Map<String, dynamic> json) {
    return PartnerUser(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}