// In: lib/features/partner/models/reservation.dart
import 'user.dart';
import 'activity.dart';

// --- CLASSE 'RESERVATION' CORRIGÉE ---
// C'est le modèle principal que nous utilisons pour les réservations unifiées.
class Reservation {
  final int id;
  final String status;
  final String reservationDate;
  final int participants;
  final String? type;
  final Activity? activity;
  final PartnerUser user;

  Reservation({
    required this.id,
    required this.status,
    required this.reservationDate,
    required this.participants,
    this.type,
    this.activity,
    required this.user,
  });

  /// Factory constructor to create a Reservation from a JSON map.
  /// CETTE VERSION EST MAINTENANT CORRECTE ET ROBUSTE.
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      // On ajoute des valeurs par défaut pour tout pour éviter les crashes.
      id: json['id'] ?? 0,
      status: json['status'] ?? 'pending',
      reservationDate: json['reservation_date'] ?? '',
      participants: json['participants'] ?? 0,
      type: json['type'], // Le type peut être null, c'est ok.

      // On parse l'objet 'activity' s'il existe.
      activity: json['activity'] != null
          ? Activity.fromJson(json['activity'])
          : null,

      // On parse l'objet 'user', en s'assurant qu'il n'est jamais null.
      user: json['user'] != null
          ? PartnerUser.fromJson(json['user'])
          : PartnerUser(id: 0, fullname: 'Unknown User', email: '', phone: '', role: 'customer'),
    );
  }
}

// --- CLASSE 'RESTAURANTRESERVATION' ---
// Ce modèle est conservé tel quel, car il est différent (utilise DateTime, guests).
class RestaurantReservation {
  final int id;
  final String status;
  final DateTime reservationDate;
  final int guests;

  RestaurantReservation({
    required this.id,
    required this.status,
    required this.reservationDate,
    required this.guests,
  });

  factory RestaurantReservation.fromJson(Map<String, dynamic> json) {
    return RestaurantReservation(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'pending',
      reservationDate: json['reservation_date'] != null ? DateTime.parse(json['reservation_date']) : DateTime.now(),
      guests: json['number_of_guests'] ?? 0,
    );
  }
}