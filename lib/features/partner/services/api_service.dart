// In: lib/features/partner/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';

// Import all your models
import '../models/activity.dart';
import '../models/user.dart';
import '../models/reservation.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../models/partner_stats.dart';

class ApiService {
  // =======================================================================
  // IMPORTANT: THIS IS THE ONLY LINE YOU'LL NEED TO CHANGE LATER
  static const String _baseUrl = 'https://insidecasa.me';
  // =======================================================================

  /// Helper method to create authenticated headers.
  Map<String, String> _getAuthHeaders(String token) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // --- AUTHENTICATION ---

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userProfile = await getMyProfile(token);
      return {'token': token, 'user': userProfile};
    } else {
      throw Exception('Failed to login. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<PartnerUser> getMyProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/users/me'),
      headers: _getAuthHeaders(token),
    );
    if (response.statusCode == 200) {
      return PartnerUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  // --- LISTING & ACTIVITY MANAGEMENT ---

  Future<List<Activity>> getActivitiesForPartner({required int partnerId, required String token}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/activities/partners/$partnerId'),
      headers: _getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Activity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activities for partner');
    }
  }

  Future<PartnerStats> getPartnerStats(String token) async {
    // NOTE: This endpoint is an assumption. You'll need to confirm it with the backend dev.
    final response = await http.get(
      Uri.parse('$_baseUrl/api/partner/stats'), // Assumed endpoint
      headers: _getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      return PartnerStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load partner statistics');
    }
  }

  Future<List<Restaurant>> getRestaurantsForPartner({required int partnerId, required String token}) async {
    // Assuming the backend filters restaurants by the authenticated partner's token.
    // The API doc says GET /api/restaurants, so we'll add the partnerId as a query parameter just in case.
    final uri = Uri.parse('$_baseUrl/api/restaurants').replace(queryParameters: {'partner_id': partnerId.toString()});
    final response = await http.get(uri, headers: _getAuthHeaders(token));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Restaurant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load restaurants for partner');
    }
  }

  Future<Activity> createActivity({
    required String token,
    required int partnerId,
    required int categoryId,
    required String title,
    required String description,
    required String location,
    required double price,
    required int duration,
    required List<XFile> images,
    double latitude = 33.5731,
    double longitude = -7.5898,
  }) async {
    var uri = Uri.parse('$_baseUrl/api/activities');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'partner_id': partnerId.toString(),
      'category_id': categoryId.toString(),
      'title': title,
      'description': description,
      'location': location,
      'price': price.toString(),
      'duration': duration.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    });

    for (var imageFile in images) {
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('images[]', stream, length, filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Activity.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to create activity. Status: ${response.statusCode}, Body: $responseBody');
    }
  }

  // In: lib/features/partner/services/api_service.dart
// Add this inside the ApiService class, for example, after createActivity.

  Future<void> deleteListing(String token, int listingId, {bool isRestaurant = false}) async {
    // Determine the correct endpoint based on the item type
    final String endpoint = isRestaurant ? 'restaurants' : 'activities';

    final response = await http.delete(
      Uri.parse('$_baseUrl/api/$endpoint/$listingId'),
      headers: _getAuthHeaders(token),
    );

    // A successful DELETE often returns 200 OK or 204 No Content.
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete listing. Status code: ${response.statusCode}');
    }
  }

  // In: lib/features/partner/services/api_service.dart

  // In: lib/features/partner/services/api_service.dart

  Future<Activity> updateActivity({
    required String token,
    required int activityId,
    required int partnerId,      // ADDED THIS
    required int categoryId,     // ADDED THIS
    required String title,
    required String description,
    required String location,
    required double price,
    required int duration,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/activities/$activityId'),
      headers: _getAuthHeaders(token),
      body: jsonEncode({
        'partner_id': partnerId,    // And included it in the body
        'category_id': categoryId,  // And included it in the body
        'title': title,
        'description': description,
        'location': location,
        'price': price,
        'duration': duration,
      }),
    );

    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update activity. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // --- RESERVATION MANAGEMENT ---

  Future<List<Reservation>> getActivityReservations(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/reservations'),
      headers: _getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Reservation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activity reservations');
    }
  }

  Future<List<RestaurantReservation>> getRestaurantReservations(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/restaurantreservations'),
      headers: _getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => RestaurantReservation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load restaurant reservations');
    }
  }

  Future<void> updateReservationStatus(String token, int reservationId, String newStatus, {bool isRestaurant = false}) async {
    final endpoint = isRestaurant ? 'restaurantreservations' : 'reservations';
    final response = await http.put(
      Uri.parse('$_baseUrl/api/$endpoint/$reservationId'),
      headers: _getAuthHeaders(token),
      body: jsonEncode({'status': newStatus}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update reservation status');
    }
  }

  // --- REVIEW MANAGEMENT ---

  Future<List<ActivityReview>> getActivityReviews(String token, {required int activityId}) async {
    final uri = Uri.parse('$_baseUrl/api/activityreviews').replace(queryParameters: {'activityId': activityId.toString()});
    final response = await http.get(uri, headers: _getAuthHeaders(token));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => ActivityReview.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activity reviews');
    }
  }
}