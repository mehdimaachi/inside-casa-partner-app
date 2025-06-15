// In: lib/features/partner/models/reservation.dart

// Corresponds to the 'Reservation' schema in your API for activities
class Reservation {
  final int id;
  final int userId;
  final int eventId;
  final int activityId;
  final int participants;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String paymentStatus;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.activityId,
    required this.participants,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      activityId: json['activity_id'],
      participants: json['participants'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// Corresponds to the 'RestaurantReservation' schema in your API
class RestaurantReservation {
  final int id;
  final int userId;
  final int restaurantId;
  final DateTime reservationDate;
  final String reservationTime;
  final int guests;
  final String status;
  final DateTime createdAt;

  RestaurantReservation({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.reservationDate,
    required this.reservationTime,
    required this.guests,
    required this.status,
    required this.createdAt,
  });

  factory RestaurantReservation.fromJson(Map<String, dynamic> json) {
    return RestaurantReservation(
      id: json['id'],
      userId: json['user_id'],
      restaurantId: json['restaurant_id'],
      reservationDate: DateTime.parse(json['reservation_date']),
      reservationTime: json['reservation_time'],
      guests: json['guests'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}