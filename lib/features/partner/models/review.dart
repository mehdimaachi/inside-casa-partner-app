// In: lib/features/partner/models/review.dart

// Corresponds to the 'ActivityReview' schema in your API
class ActivityReview {
  final int id;
  final int userId;
  final int activityId;
  final int rating; // 1-5
  final String comment;
  final DateTime createdAt;
  // It's very useful if the API can also send the user's name
  // final String? userName;

  ActivityReview({
    required this.id,
    required this.userId,
    required this.activityId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    // this.userName,
  });

  factory ActivityReview.fromJson(Map<String, dynamic> json) {
    return ActivityReview(
      id: json['id'],
      userId: json['user_id'],
      activityId: json['activity_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      // Example of how to parse if the backend includes user info
      // userName: json['user'] != null ? json['user']['fullname'] : 'Anonymous',
    );
  }
}


// Corresponds to the 'RestaurantReview' schema in your API
class RestaurantReview {
  final int id;
  final int userId;
  final int restaurantId;
  final int rating; // 1-5
  final String comment;
  final DateTime createdAt;
  // final String? userName;

  RestaurantReview({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    // this.userName,
  });

  factory RestaurantReview.fromJson(Map<String, dynamic> json) {
    return RestaurantReview(
      id: json['id'],
      userId: json['user_id'],
      restaurantId: json['restaurant_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      // userName: json['user'] != null ? json['user']['fullname'] : 'Anonymous',
    );
  }
}