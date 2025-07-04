import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import all your models
import '../models/activity.dart';
import '../models/user.dart';
import '../models/reservation.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../models/partner_stats.dart';
import '../services/mock_service.dart';

class ApiService {
  static const String _baseUrl = 'https://insidecasa.me';

  Map<String, String> _getAuthHeaders(String token) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // --- AUTHENTICATION & USER MANAGEMENT ---

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data['token'] == null) {
        throw Exception('Login failed: Server response did not include a token.');
      }
      final userProfile = await getMyProfile(data['token']);
      return {'token': data['token'], 'user': userProfile};
    } else if (response.statusCode == 429) {
      throw Exception('Too many login attempts. Please wait a minute and try again.');
    } else {
      throw Exception(data['message'] ?? 'Login failed');
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

  Future<void> registerPartner({
    required String businessName,
    required String contactName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'fullname': contactName, 'email': email, 'password': password,
        'phone': phone, 'description': businessName, 'role': 'partner',
      }),
    );
    if (response.statusCode != 201) {
      final errorData = json.decode(response.body);
      throw Exception('Failed to register: ${errorData['message'] ?? 'An unknown error occurred.'}');
    }
  }

  // --- NEWLY ADDED: updateUserProfile ---
  Future<PartnerUser> updateUserProfile({
    required String token,
    required String fullname,
    required String phone,
    required String description,
  }) async {
    final url = Uri.parse('$_baseUrl/api/users/me');
    final response = await http.put(
      url,
      headers: _getAuthHeaders(token),
      body: json.encode({
        'fullname': fullname,
        'phone': phone,
        'description': description,
      }),
    );
    if (response.statusCode == 200) {
      return PartnerUser.fromJson(json.decode(response.body));
    } else {
      final errorData = json.decode(response.body);
      throw Exception('Failed to update profile: ${errorData['message'] ?? 'An unknown error occurred.'}');
    }
  }

  // --- NEWLY ADDED: changePassword ---
  Future<void> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/api/users/change-password');
    final response = await http.put(
      url,
      headers: _getAuthHeaders(token),
      body: json.encode({
        'currentPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to change password.');
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

  Future<List<Restaurant>> getRestaurantsForPartner({required int partnerId, required String token}) async {
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
    required String token, required int partnerId, required int categoryId,
    required String title, required String description, required String location,
    required double price, required int duration, required List<XFile> images,
    double latitude = 33.5731, double longitude = -7.5898,
  }) async {
    var uri = Uri.parse('$_baseUrl/api/activities');
    var request = http.MultipartRequest('POST', uri)..headers['Authorization'] = 'Bearer $token';
    request.fields.addAll({
      'partner_id': partnerId.toString(), 'category_id': categoryId.toString(),
      'title': title, 'description': description, 'location': location,
      'price': price.toString(), 'duration': duration.toString(),
      'latitude': latitude.toString(), 'longitude': longitude.toString(),
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

  Future<void> deleteListing(String token, int listingId, {bool isRestaurant = false}) async {
    final String endpoint = isRestaurant ? 'restaurants' : 'activities';
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/$endpoint/$listingId'),
      headers: _getAuthHeaders(token),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete listing. Status code: ${response.statusCode}');
    }
  }

  Future<Activity> updateActivity({
    required String token, required int activityId, required int partnerId,
    required int categoryId, required String title, required String description,
    required String location, required double price, required int duration,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/activities/$activityId'),
      headers: _getAuthHeaders(token),
      body: jsonEncode({
        'partner_id': partnerId, 'category_id': categoryId, 'title': title,
        'description': description, 'location': location, 'price': price,
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

  Future<List<Reservation>> getPartnerReservations({String status = 'all'}) async {
    try {
      // Use MockService to fetch reservations
      final mockService = MockService();
      return await mockService.getPartnerReservations(status: status);
    } catch (e) {
      throw Exception('Error fetching reservations: $e');
    }
  }

  Future<bool> updateReservationStatus(String token, int reservationId, String newStatus, {bool isRestaurant = false}) async {
    try {
      final endpoint = isRestaurant ? 'restaurantreservations' : 'reservations';
      final response = await http.put(
        Uri.parse('$_baseUrl/api/$endpoint/$reservationId'),
        headers: _getAuthHeaders(token),
        body: jsonEncode({'status': newStatus}),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update reservation status: $e');
    }
  }

  // --- REVIEW MANAGEMENT ---

  Future<List<Review>> getActivityReviews(String token, {required int activityId}) async {
    final uri = Uri.parse('$_baseUrl/api/activityreviews').replace(queryParameters: {'activityId': activityId.toString()});
    final response = await http.get(uri, headers: _getAuthHeaders(token));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Review.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activity reviews');
    }
  }

  Future<List<Review>> getPartnerReviews() async {
    try {
      final token = await getStoredToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/partner/reviews'),
        headers: _getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  Future<String> getStoredToken() async {
    const secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('No authentication token found. Please login again.');
    }
    return token;
  }

  Future<bool> replyToReview(int reviewId, String replyText) async {
    try {
      final token = await getStoredToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/api/partner/reviews/$reviewId/reply'),
        headers: _getAuthHeaders(token),
        body: json.encode({'reply_text': replyText}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error replying to review: $e');
    }
  }
}