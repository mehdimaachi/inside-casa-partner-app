// In: lib/features/partner/models/user.dart

class PartnerUser {
  final int id;
  final String fullname;
  final String email;
  final String phone;
  final String? status;
  final String? description;
  final String role;

  PartnerUser({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phone,
    this.status,
    this.description,
    required this.role,
  });

  factory PartnerUser.fromJson(Map<String, dynamic> json) {
    return PartnerUser(
      // --- THIS IS THE FIX ---
      // We provide a default value (like 0) if the 'id' field is null
      // in the JSON response. This prevents the crash after an update.
      id: json['id'] ?? 0,

      // The rest of the safeguards are already in place.
      fullname: json['fullname'] ?? 'No Name Provided',
      email: json['email'] ?? 'No Email Provided',
      phone: json['phone'] ?? 'No Phone Provided',
      status: json['status'],
      description: json['description'],
      role: json['role'] ?? 'customer',
    );
  }
}