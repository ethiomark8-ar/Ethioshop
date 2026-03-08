import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/review_entity.dart';
import '../../providers/review_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  final String productId;
  final String productName;

  const ReviewsScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewProvider.notifier).loadProductReviews(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: reviewState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reviewState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('Error: ${reviewState.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(reviewProvider.notifier).clearError();
                          ref.read(reviewProvider.notifier).loadProductReviews(widget.productId);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : reviewState.reviews.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        // Summary Card
                        _buildSummaryCard(reviewState),
                        const Divider(height: 1),
                        // Reviews List
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: reviewState.reviews.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final review = reviewState.reviews[index];
                              return _buildReviewCard(review);
                            },
                          ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/product/${widget.productId}/write-review'),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Write Review'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to review this product',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ReviewState reviewState) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Average Rating
          Row(
            children: [
              Text(
                reviewState.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < reviewState.averageRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: AppTheme.primaryYellow,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${reviewState.reviews.length} review${reviewState.reviews.length != 1 ? 's' : ''}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Rating Distribution
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final count = reviewState.ratingDistribution[rating] ?? 0;
            final percentage = reviewState.reviews.isEmpty
                ? 0.0
                : (count / reviewState.reviews.length) * 100;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text('$rating'),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, size: 14, color: AppTheme.primaryYellow),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 30,
                    child: Text(
                      count.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewEntity review) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: review.userImage != null
                      ? NetworkImage(review.userImage!)
                      : null,
                  child: review.userImage == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        dateFormat.format(review.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: AppTheme.primaryYellow,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Review comment
            Text(
              review.comment,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),

            // Helpful button
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ref.read(reviewProvider.notifier).markHelpful(review.id);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Helpful (${review.helpfulCount})',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
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