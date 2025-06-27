import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../services/mock_service.dart';
import 'package:shimmer/shimmer.dart';

class ManageReviewsScreen extends StatefulWidget {
  static const routeName = '/manage-reviews';

  const ManageReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ManageReviewsScreen> createState() => _ManageReviewsScreenState();
}

class _ManageReviewsScreenState extends State<ManageReviewsScreen> {
  final ApiService _apiService = ApiService();
  final MockService _mockService = MockService();

  List<Review> reviews = [];
  bool isLoading = true;
  String? error;
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Essayer d'abord l'API réelle
      try {
        final apiReviews = await _apiService.getPartnerReviews();
        setState(() {
          reviews = apiReviews;
          isLoading = false;
        });
      } catch (apiError) {
        print("API Error: $apiError");
        // En cas d'échec, utiliser les données mock
        final mockReviews = await _mockService.getPartnerReviews();
        setState(() {
          reviews = mockReviews;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  // Méthode pour répondre à un avis
  Future<void> _replyToReview(Review review) async {
    if (_isReplying) return; // Éviter les clics multiples

    final TextEditingController replyController = TextEditingController();
    replyController.text = review.replyText ?? '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Répondre à l\'avis'),
        content: TextField(
          controller: replyController,
          decoration: InputDecoration(
            hintText: 'Écrivez votre réponse ici...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, replyController.text),
            child: Text('Envoyer'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _isReplying = true;
      });

      try {
        bool success = false;

        try {
          // Essayer l'API réelle
          success = await _apiService.replyToReview(review.id, result);
        } catch (apiError) {
          // Utiliser le mock en cas d'échec
          success = await _mockService.replyToReview(review.id, result);
        }

        if (success) {
          setState(() {
            // Mettre à jour l'avis localement
            final index = reviews.indexWhere((r) => r.id == review.id);
            if (index != -1) {
              reviews[index] = review.copyWith(
                replied: true,
                replyText: result,
              );
            }
            _isReplying = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Réponse publiée avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Échec de la publication de la réponse'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isReplying = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isReplying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Reviews'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isLoading ? null : _loadReviews,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingShimmer()
          : error != null
          ? _buildErrorView()
          : reviews.isEmpty
          ? _buildEmptyView()
          : RefreshIndicator(
        onRefresh: _loadReviews,
        child: ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return _buildReviewCard(context, review);
          },
        ),
      ),
    );
  }

  // Widget pour l'effet de chargement
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
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
                      Container(
                        width: 200,
                        height: 20,
                        color: Colors.white,
                      ),
                      Container(
                        width: 80,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 1,
                    color: Colors.white,
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 4),
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      );
                    }),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 100,
                      height: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget pour afficher une erreur
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Erreur lors du chargement des avis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              error ?? 'Une erreur inconnue est survenue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadReviews,
            icon: Icon(Icons.refresh),
            label: Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher un état vide
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.reviews_outlined,
            color: Colors.grey[400],
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Aucun avis pour le moment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Les avis de vos clients apparaîtront ici',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher un avis
  Widget _buildReviewCard(BuildContext context, Review review) {
    String formattedDate = '';
    try {
      final date = review.date;
      formattedDate = '${date.day} ${_getMonthName(date.month)}, ${date.year}';
    } catch (e) {
      formattedDate = '';
    }

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
                    review.activityName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- ${review.userName}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),

            // Afficher la réponse s'il y en a une
            if (review.replied && review.replyText != null) ...[
              const Divider(height: 24),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Votre réponse:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(review.replyText!),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _replyToReview(review),
                        child: Text('Modifier'),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => _replyToReview(review),
                  icon: Icon(Icons.reply, size: 18),
                  label: Text('Répondre'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Méthode utilitaire pour obtenir le nom du mois
  String _getMonthName(int month) {
    const monthNames = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    }
    return '';
  }
}