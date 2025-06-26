import 'package:flutter/material.dart';

class ManageReviewsScreen extends StatelessWidget {
  static const routeName = '/manage-reviews';

  const ManageReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Reviews'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          _buildReviewCard(
            context,
            customerName: 'Alice Johnson',
            rating: 5,
            reviewText: 'An absolutely fantastic experience! The guide was knowledgeable and friendly. Highly recommended!',
            date: 'June 20, 2025',
            listingName: 'Historic City Walking Tour',
          ),
          _buildReviewCard(
            context,
            customerName: 'Bob Williams',
            rating: 4,
            reviewText: 'Great value and a lot of fun. The food was delicious. One star off because it was a bit crowded.',
            date: 'June 18, 2025',
            listingName: 'Seafood Masterclass',
          ),
          _buildReviewCard(
            context,
            customerName: 'Nissrine Rahma',
            rating: 3,
            reviewText: 'It was okay. The location was beautiful, but the activity felt a bit rushed. Might try again on a less busy day.',
            date: 'June 15, 2025',
            listingName: 'Sunset Kayaking Adventure',
          ),
          _buildReviewCard(
            context,
            customerName: 'Ahmed Chadli',
            rating: 5,
            reviewText: 'Perfect in every way. A must-do activity for anyone visiting the area. I will definitely be back!',
            date: 'June 12, 2025',
            listingName: 'Mountain Hiking Expedition',
          ),
        ],
      ),
    );
  }

  // A helper widget to create a consistent UI for each review card.
  Widget _buildReviewCard(BuildContext context, {
    required String customerName,
    required int rating,
    required String reviewText,
    required String date,
    required String listingName,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    listingName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              reviewText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- $customerName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}