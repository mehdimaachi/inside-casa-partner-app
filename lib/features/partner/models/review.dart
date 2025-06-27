// Fichier: lib/features/partner/models/review.dart
class Review {
  final int id;
  final int rating;
  final String comment;
  final String userName;
  final DateTime date;
  final String activityName;
  final bool replied;
  final String? replyText;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.date,
    required this.activityName,
    this.replied = false,
    this.replyText,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();

      if (date is String) {
        try {
          return DateTime.parse(date);
        } catch (_) {}
      }

      return DateTime.now();
    }

    return Review(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      userName: json['user_name'] ?? 'Anonymous',
      date: parseDate(json['date']),
      activityName: json['activity_name'] ?? 'Unknown Activity',
      replied: json['replied'] ?? false,
      replyText: json['reply_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user_name': userName,
      'date': date.toIso8601String(),
      'activity_name': activityName,
      'replied': replied,
      'reply_text': replyText,
    };
  }

  Review copyWith({
    int? id,
    int? rating,
    String? comment,
    String? userName,
    DateTime? date,
    String? activityName,
    bool? replied,
    String? replyText,
  }) {
    return Review(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      activityName: activityName ?? this.activityName,
      replied: replied ?? this.replied,
      replyText: replyText ?? this.replyText,
    );
  }
}