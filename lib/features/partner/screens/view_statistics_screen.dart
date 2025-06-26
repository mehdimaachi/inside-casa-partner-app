import 'package:flutter/material.dart';

class ViewStatisticsScreen extends StatelessWidget {
  static const routeName = '/view-statistics';

  const ViewStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Statistics'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Summary Cards ---
            _buildStatCard(
              context: context,
              icon: Icons.attach_money,
              label: 'Total Revenue',
              value: '\$ 1,234.56', // Static placeholder data
              color: Colors.green.shade600,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context: context,
              icon: Icons.calendar_today,
              label: 'Total Bookings',
              value: '78', // Static placeholder data
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context: context,
              icon: Icons.star_outline_rounded,
              label: 'Average Rating',
              value: '4.7 / 5.0', // Static placeholder data
              color: Colors.orange.shade600,
            ),
            const SizedBox(height: 32),

            // --- Chart Section ---
            Text(
              'Monthly Bookings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 10),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 50, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Monthly bookings chart will be displayed here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper widget to build the summary cards for a consistent look.
  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}