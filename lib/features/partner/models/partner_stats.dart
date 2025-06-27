// Fichier: lib/features/partner/models/partner_stats.dart
class PartnerStats {
  final double totalRevenue;
  final int totalBookings;
  final double averageRating;
  final List<MonthlyData> monthlyBookings;
  final List<ListingPerformance> topListings;
  final Map<String, dynamic> additionalStats;

  PartnerStats({
    required this.totalRevenue,
    required this.totalBookings,
    required this.averageRating,
    required this.monthlyBookings,
    this.topListings = const [],
    this.additionalStats = const {},
  });

  factory PartnerStats.fromJson(Map<String, dynamic> json) {
    List<MonthlyData> monthlyData = [];
    if (json['monthly_bookings'] != null) {
      monthlyData = (json['monthly_bookings'] as List)
          .map((item) => MonthlyData.fromJson(item))
          .toList();
    }

    List<ListingPerformance> topListings = [];
    if (json['top_listings'] != null) {
      topListings = (json['top_listings'] as List)
          .map((item) => ListingPerformance.fromJson(item))
          .toList();
    }

    return PartnerStats(
      totalRevenue: json['total_revenue'] != null
          ? double.tryParse(json['total_revenue'].toString()) ?? 0.0
          : 0.0,
      totalBookings: json['total_bookings'] ?? 0,
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString()) ?? 0.0
          : 0.0,
      monthlyBookings: monthlyData,
      topListings: topListings,
      additionalStats: json['additional_stats'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_bookings': totalBookings,
      'average_rating': averageRating,
      'monthly_bookings': monthlyBookings.map((item) => item.toJson()).toList(),
      'top_listings': topListings.map((item) => item.toJson()).toList(),
      'additional_stats': additionalStats,
    };
  }
}

class MonthlyData {
  final String month;
  final int value;

  MonthlyData({
    required this.month,
    required this.value,
  });

  factory MonthlyData.fromJson(Map<String, dynamic> json) {
    return MonthlyData(
      month: json['month'] ?? '',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'value': value,
    };
  }

  String getDisplayMonth() {
    // Format "YYYY-MM" en nom du mois
    try {
      final parts = month.split('-');
      if (parts.length >= 2) {
        final monthNum = int.tryParse(parts[1]);
        if (monthNum != null && monthNum >= 1 && monthNum <= 12) {
          const monthNames = ['Jan', 'Fév', 'Mars', 'Avr', 'Mai', 'Juin',
            'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc'];
          return monthNames[monthNum - 1];
        }
      }
    } catch (e) {
      // Ignore les erreurs
    }
    return month;
  }
}

class ListingPerformance {
  final String title;
  final int bookingCount;
  final double revenue;
  final String type;
  final int id;

  ListingPerformance({
    required this.title,
    required this.bookingCount,
    required this.revenue,
    required this.type,
    required this.id,
  });

  factory ListingPerformance.fromJson(Map<String, dynamic> json) {
    return ListingPerformance(
      title: json['title'] ?? '',
      bookingCount: json['booking_count'] ?? 0,
      revenue: json['revenue'] != null
          ? double.tryParse(json['revenue'].toString()) ?? 0.0
          : 0.0,
      type: json['type'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'booking_count': bookingCount,
      'revenue': revenue,
      'type': type,
      'id': id,
    };
  }
}