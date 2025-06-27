import 'user.dart';
import 'activity.dart';
import 'restaurant.dart';

// --- CLASSE 'RESERVATION' AMÉLIORÉE ---
// Modèle principal utilisé pour les réservations unifiées
class Reservation {
  final int id;
  final String status; // pending, confirmed, cancelled
  final String reservationDate;
  final int participants;
  final String? type; // activity ou restaurant
  final Activity? activity;
  final Restaurant? restaurant;
  final PartnerUser user;
  final double? totalPrice; // Prix total de la réservation

  Reservation({
    required this.id,
    required this.status,
    required this.reservationDate,
    required this.participants,
    this.type,
    this.activity,
    this.restaurant,
    required this.user,
    this.totalPrice,
  });

  /// Factory constructor pour créer une Reservation à partir d'un map JSON.
  /// Version robuste avec des valeurs par défaut pour éviter les crashs
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'pending',
      reservationDate: json['reservation_date'] ?? '',
      participants: json['participants'] ?? 0,
      type: json['type'], // Le type peut être null, c'est ok

      // On parse l'objet 'activity' s'il existe
      activity: json['activity'] != null
          ? Activity.fromJson(json['activity'])
          : null,

      // On parse l'objet 'restaurant' s'il existe
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'])
          : null,

      // On parse l'objet 'user', en s'assurant qu'il n'est jamais null
      user: json['user'] != null
          ? PartnerUser.fromJson(json['user'])
          : PartnerUser(id: 0, fullname: 'Unknown User', email: '', phone: '', role: 'customer'),

      // On récupère le prix total s'il existe
      totalPrice: json['total_price'] != null
          ? double.tryParse(json['total_price'].toString()) ?? 0.0
          : null,
    );
  }

  /// Convertit la réservation en format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'reservation_date': reservationDate,
      'participants': participants,
      'type': type,
      'activity': activity?.toJson(),
      'restaurant': restaurant?.toJson(),
      'user': user.toJson(),
      'total_price': totalPrice,
    };
  }

  /// Utilitaire pour obtenir le nom du listing (activité ou restaurant)
  String get listingName {
    if (activity != null) return activity!.title;  // Utiliser title au lieu de name
    if (restaurant != null) return restaurant!.name;
    return 'Réservation #$id';
  }

  /// Utilitaire pour obtenir le prix de la réservation
  double get price {
    if (totalPrice != null) return totalPrice!;
    if (activity != null) {
      // Calculer le prix en fonction du nombre de participants
      return activity!.price * participants;
    }
    return 0.0;
  }

  /// Utilitaire pour formater la date de réservation
  DateTime getFormattedDate() {
    try {
      return DateTime.parse(reservationDate);
    } catch (e) {
      // En cas d'erreur de format, retourner la date actuelle
      return DateTime.now();
    }
  }
}

// --- CLASSE 'RESTAURANTRESERVATION' ---
// Ce modèle est conservé tel quel pour la compatibilité avec le code existant
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
      reservationDate: json['reservation_date'] != null
          ? DateTime.parse(json['reservation_date'])
          : DateTime.now(),
      guests: json['number_of_guests'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'reservation_date': reservationDate.toIso8601String(),
      'number_of_guests': guests,
    };
  }
}

// Ajout d'une classe pour faciliter la création de réservations mock
class MockReservationHelper {
  /// Crée une réservation mock pour l'écran de gestion des réservations
  static Reservation createMockReservation({
    required int id,
    required String status,
    required String activityName,
    required String userName,
    required DateTime date,
    int participants = 2,
    double price = 200.0,
  }) {
    return Reservation(
      id: id,
      status: status,
      reservationDate: date.toIso8601String(),
      participants: participants,
      type: 'activity',
      activity: Activity(
        id: 1000 + id,
        title: activityName,  // Utiliser title au lieu de name
        description: 'Description de $activityName',
        location: 'Casablanca',
        latitude: 33.589886,
        longitude: -7.603869,
        price: price / participants,
        duration: 120,
        isActive: true,
        imageUrls: [],
        categoryId: 1,
        partnerId: 10,
        isPromoted: false,
      ),
      user: PartnerUser(
        id: 2000 + id,
        fullname: userName,
        email: '${userName.toLowerCase().replaceAll(' ', '.')}@example.com',
        phone: '+212 6${(600000 + id).toString()}',
        role: 'customer',
      ),
      totalPrice: price,
    );
  }
}