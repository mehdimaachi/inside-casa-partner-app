// In: lib/features/partner/models/partner_stats.dart

class PartnerStats {
  final double totalRevenue;
  final int totalBookings;
  final List<MonthlyBooking> bookingsPerMonth; // For a bar chart
  final List<ListingPerformance> topListings;   // For a list view

  PartnerStats({
    required this.totalRevenue,
    required this.totalBookings,
    required this.bookingsPerMonth,
    required this.topListings,
  });

  factory PartnerStats.fromJson(Map<String, dynamic> json) {
    return PartnerStats(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalBookings: json['totalBookings'] as int,
      bookingsPerMonth: (json['bookingsPerMonth'] as List)
          .map((i) => MonthlyBooking.fromJson(i))
          .toList(),
      topListings: (json['topListings'] as List)
          .map((i) => ListingPerformance.fromJson(i))
          .toList(),
    );
  }
}

class MonthlyBooking {
  final String month; // e.g., "Jan", "Feb"
  final int count;
  MonthlyBooking({required this.month, required this.count});
  factory MonthlyBooking.fromJson(Map<String, dynamic> json) {
    return MonthlyBooking(month: json['month'], count: json['count']);
  }
}

class ListingPerformance {
  final String title;
  final int bookingCount;
  ListingPerformance({required this.title, required this.bookingCount});
  factory ListingPerformance.fromJson(Map<String, dynamic> json) {
    return ListingPerformance(title: json['title'], bookingCount: json['bookingCount']);
  }
}