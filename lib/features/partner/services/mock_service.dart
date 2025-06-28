import 'dart:math';
import '../models/reservation.dart';
import '../models/review.dart';
import '../models/partner_stats.dart';
import '../models/user.dart';
import '../models/activity.dart';
import '../models/restaurant.dart';

class MockService {
  // Singleton pattern
  static final MockService _instance = MockService._internal();
  final Map<int, bool> mockPromotionStatuses = {};

  factory MockService() => _instance;

  MockService._internal() {
    // Initialize mock data for listings
    mockPromotionStatuses[1] = false;
    mockPromotionStatuses[2] = true;
    mockPromotionStatuses[3] = false;
    mockPromotionStatuses[4] = true;
    mockPromotionStatuses[5] = false;
    mockPromotionStatuses[6] = false;
    mockPromotionStatuses[7] = false;
    mockPromotionStatuses[8] = false;
  }

  Future<Map<String, dynamic>> togglePromotionStatus(int listingId) async {
    // Simulate a short delay to mimic an API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mockPromotionStatuses.containsKey(listingId)) {
      throw Exception('Listing not found');
    }

    // Toggle the promotion status
    mockPromotionStatuses[listingId] = !mockPromotionStatuses[listingId]!;

    // Return the updated status
    return {
      'id': listingId,
      'isPromoted': mockPromotionStatuses[listingId],
    };
  }

  // Mock data for reservations
  Future<List<Reservation>> getPartnerReservations({String status = 'all'}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock reservations directly
    List<Reservation> allReservations = _generateMockReservations();

    // Filter by status if specified
    if (status != 'all') {
      return allReservations.where((res) => res.status == status).toList();
    }

    return allReservations;
  }

  // Internal method to generate mock reservations
  List<Reservation> _generateMockReservations() {
    return [
      Reservation(
        id: 1,
        status: "pending",
        reservationDate: DateTime.now().add(Duration(days: 2)).toIso8601String(),
        participants: 2,
        type: 'activity',
        activity: Activity(
          id: 101,
          title: "Randonnée urbaine dans le quartier des Habous",
          description: "Une randonnée culturelle guidée",
          location: "Quartier des Habous, Casablanca",
          latitude: 33.589886,
          longitude: -7.603869,
          price: 120.0,
          duration: 180,
          isActive: true,
          imageUrls: [],
          categoryId: 1,
          partnerId: 10,
        ),
        user: PartnerUser(
          id: 201,
          fullname: "Ahmed Benali",
          email: "ahmed.benali@example.com",
          phone: "+212 612345678",
          role: "customer",
        ),
        totalPrice: 240.0,
      ),
      Reservation(
        id: 2,
        status: "confirmed",
        reservationDate: DateTime.now().add(Duration(days: 5)).toIso8601String(),
        participants: 1,
        type: 'activity',
        activity: Activity(
          id: 102,
          title: "Séance de surf à la plage Ain Diab",
          description: "Cours de surf pour tous niveaux",
          location: "Plage Ain Diab, Casablanca",
          latitude: 33.603543,
          longitude: -7.701401,
          price: 250.0,
          duration: 120,
          isActive: true,
          imageUrls: [],
          categoryId: 2,
          partnerId: 10,
        ),
        user: PartnerUser(
          id: 202,
          fullname: "Leila Kadiri",
          email: "leila.k@example.com",
          phone: "+212 613345678",
          role: "customer",
        ),
        totalPrice: 250.0,
      ),
      Reservation(
        id: 3,
        status: "cancelled",
        reservationDate: DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        participants: 4,
        type: 'activity',
        activity: Activity(
          id: 103,
          title: "Visite guidée de la cathédrale du Sacré-Cœur",
          description: "Découvrez l'architecture néo-gothique",
          location: "Boulevard Rachidi, Casablanca",
          latitude: 33.592464,
          longitude: -7.632260,
          price: 80.0,
          duration: 90,
          isActive: true,
          imageUrls: [],
          categoryId: 3,
          partnerId: 10,
        ),
        user: PartnerUser(
          id: 203,
          fullname: "Omar Tazi",
          email: "omar.t@example.com",
          phone: "+212 614445678",
          role: "customer",
        ),
        totalPrice: 320.0,
      ),
      Reservation(
        id: 4,
        status: "pending",
        reservationDate: DateTime.now().add(Duration(days: 3)).toIso8601String(),
        participants: 2,
        type: 'activity',
        activity: Activity(
          id: 104,
          title: "Atelier de cuisine marocaine à Maarif",
          description: "Apprenez à cuisiner des plats traditionnels marocains",
          location: "Maarif, Casablanca",
          latitude: 33.584667,
          longitude: -7.636111,
          price: 300.0,
          duration: 240,
          isActive: true,
          imageUrls: [],
          categoryId: 4,
          partnerId: 10,
        ),
        user: PartnerUser(
          id: 204,
          fullname: "Fatima Alaoui",
          email: "fatima.alaoui@example.com",
          phone: "+212 612345679",
          role: "customer",
        ),
        totalPrice: 600.0,
      ),
      Reservation(
        id: 5,
        status: "confirmed",
        reservationDate: DateTime.now().add(Duration(days: 1)).toIso8601String(),
        participants: 2,
        type: 'restaurant',
        restaurant: Restaurant(
          id: 201,
          name: "Restaurant La Sqala",
          description: "Cuisine marocaine traditionnelle",
          address: "Boulevard des Almohades, Casablanca",
          phone: "+212 522 26 09 60",
          rating: 4.5,
          category: "Marocaine",
          price_range: "\$\$",
          opening_hours: "10:00-23:00",
          image_url: "https://example.com/images/lasqala.jpg",
          partner_id: 10,
        ),
        user: PartnerUser(
          id: 205,
          fullname: "Karim Sabri",
          email: "karim.sabri@example.com",
          phone: "+212 612345680",
          role: "customer",
        ),
        totalPrice: 150.0,
      ),
    ];
  }

  // Update reservation status
  Future<bool> updateReservationStatus(int reservationId, String newStatus) async {
    await Future.delayed(Duration(milliseconds: 600));
    // Simulate a successful response
    return true;
  }

  // Add confirmBooking method for compatibility
  Future<void> confirmBooking(int reservationId) async {
    try {
      final isUpdated = await updateReservationStatus(reservationId, "confirmed");
      if (isUpdated) {
        print("Reservation $reservationId confirmed successfully.");
      } else {
        print("Failed to confirm reservation $reservationId.");
      }
    } catch (e) {
      print("Error confirming reservation $reservationId: $e");
    }
  }



  // Mock data for reviews
  Future<List<Review>> getPartnerReviews() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 700));

    // Generate reviews directly
    return _getMockReviews();
  }

  // Internal method to generate mock reviews
  List<Review> _getMockReviews() {
    return [
      Review(
        id: 1,
        rating: 5,
        comment: "An absolutely fantastic experience! The guide was knowledgeable and friendly. Highly recommended!",
        userName: "Alice Johnson",
        date: DateTime(2025, 6, 20),
        activityName: "Historic City Walking Tour",
        replied: false,
      ),
      Review(
        id: 2,
        rating: 4,
        comment: "Great value and a lot of fun. The food was delicious. One star off because it was a bit crowded.",
        userName: "Bob Williams",
        date: DateTime(2025, 6, 18),
        activityName: "Seafood Masterclass",
        replied: true,
        replyText: "Thank you for your feedback! We're looking into ways to make the experience less crowded.",
      ),
      Review(
        id: 3,
        rating: 3,
        comment: "It was okay. The location was beautiful, but the activity felt a bit rushed. Might try again on a less busy day.",
        userName: "Nissrine Rahma",
        date: DateTime(2025, 6, 15),
        activityName: "Sunset Kayaking Adventure",
        replied: false,
      ),
      Review(
        id: 4,
        rating: 5,
        comment: "Amazing views and a very well organized expedition. The guide knew all the best spots for photos.",
        userName: "Mohammed Idrissi",
        date: DateTime(2025, 6, 12),
        activityName: "Mountain Hiking Expedition",
        replied: true,
        replyText: "We're delighted you enjoyed the expedition! Thank you for your kind words.",
      ),
    ];
  }

  // Reply to a review
  Future<bool> replyToReview(int reviewId, String replyText) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 600));
    // Simulate a successful response
    return true;
  }

  // Mock data for statistics
  Future<PartnerStats> getPartnerStatistics() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 900));

    // Generate realistic statistics directly
    return _generateMockStats();
  }

// Internal method to generate realistic mock statistics
  PartnerStats _generateMockStats() {
    // Monthly data for the first half of the year (Jan to Jun)
    final List<MonthlyData> monthlyData = [
      MonthlyData(month: '2025-01', value: 16), // January
      MonthlyData(month: '2025-02', value: 20), // February
      MonthlyData(month: '2025-03', value: 12), // March
      MonthlyData(month: '2025-04', value: 13), // April
      MonthlyData(month: '2025-05', value: 6),  // May
      MonthlyData(month: '2025-06', value: 24), // June
    ];

    // Calculate total bookings and revenue based on monthly data
    final int totalBookings = monthlyData.fold(0, (sum, data) => sum + data.value);
    final double totalRevenue = totalBookings * 60.0; // Assume average revenue per booking is $60.00

    // Generate other realistic statistics
    return PartnerStats(
      totalRevenue: totalRevenue,
      totalBookings: totalBookings,
      averageRating: 4.7, // Static average rating
      monthlyBookings: monthlyData,
      topListings: [
        ListingPerformance(
          title: 'Tour de la Médina',
          bookingCount: 24,
          revenue: 1440.0,
          type: 'activity',
          id: 101,
        ),
        ListingPerformance(
          title: 'Restaurant La Sqala',
          bookingCount: 18,
          revenue: 1080.0,
          type: 'restaurant',
          id: 201,
        ),
        ListingPerformance(
          title: 'Cours de cuisine marocaine',
          bookingCount: 15,
          revenue: 900.0,
          type: 'activity',
          id: 102,
        ),
      ],
      additionalStats: {
        'completionRate': 91.0, // Slightly adjusted to be realistic
        'cancellationRate': 9.0, // Slightly adjusted to be realistic
        'repeatCustomers': 14,   // Increased slightly for realism
      },
    );
  }

  // Get the list of activities
  Future<List<Activity>> getPartnerActivities() async {
    await Future.delayed(Duration(milliseconds: 700));

    return [
      Activity(
        id: 101,
        title: "Randonnée urbaine dans le quartier des Habous",
        description: "Une randonnée culturelle guidée à travers l'un des quartiers les plus historiques de Casablanca.",
        location: "Quartier des Habous, Casablanca",
        latitude: 33.589886,
        longitude: -7.603869,
        price: 120.0,
        duration: 180,
        isActive: true,
        imageUrls: [],
        categoryId: 1,
        partnerId: 10,
      ),
      Activity(
        id: 102,
        title: "Séance de surf à la plage Ain Diab",
        description: "Cours de surf pour tous niveaux avec équipement inclus.",
        location: "Plage Ain Diab, Casablanca",
        latitude: 33.603543,
        longitude: -7.701401,
        price: 250.0,
        duration: 120,
        isActive: true,
        imageUrls: [],
        categoryId: 2,
        partnerId: 10,
      ),
      Activity(
        id: 103,
        title: "Visite guidée de la cathédrale du Sacré-Cœur",
        description: "Découvrez l'architecture néo-gothique de cette cathédrale emblématique.",
        location: "Boulevard Rachidi, Casablanca",
        latitude: 33.592464,
        longitude: -7.632260,
        price: 80.0,
        duration: 90,
        isActive: true,
        imageUrls: [],
        categoryId: 3,
        partnerId: 10,
      ),
    ];
  }

  // Get the list of restaurants
  Future<List<Restaurant>> getPartnerRestaurants() async {
    await Future.delayed(Duration(milliseconds: 700));

    return [
      Restaurant(
        id: 201,
        name: "Restaurant La Sqala",
        description: "Cuisine marocaine traditionnelle servie dans un cadre historique.",
        address: "Boulevard des Almohades, Casablanca",
        phone: "+212 522 26 09 60",
        rating: 4.5,
        category: "Marocaine",
        price_range: "\$\$",
        opening_hours: "10:00-23:00",
        image_url: "https://example.com/images/lasqala.jpg",
        partner_id: 10,
      ),
      Restaurant(
        id: 202,
        name: "Le Rouget de l'Isle",
        description: "Restaurant français élégant offrant une cuisine raffinée.",
        address: "Rue Rouget de L'Isle, Casablanca",
        phone: "+212 522 48 26 67",
        rating: 4.3,
        category: "Française",
        price_range: "\$\$\$",
        opening_hours: "12:00-15:00,19:00-23:00",
        image_url: "https://example.com/images/rouget.jpg",
        partner_id: 10,
      ),
    ];
  }
}