import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/review_entity.dart';

// Review State
class ReviewState {
  final List<ReviewEntity> reviews;
  final ReviewEntity? userReview;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final double averageRating;

  const ReviewState({
    this.reviews = const [],
    this.userReview,
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.averageRating = 0.0,
  });

  ReviewState copyWith({
    List<ReviewEntity>? reviews,
    ReviewEntity? userReview,
    bool? isLoading,
    String? error,
    bool? hasMore,
    double? averageRating,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      userReview: userReview ?? this.userReview,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  Map<int, int> get ratingDistribution {
    final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }
    return distribution;
  }
}

// Review Notifier
class ReviewNotifier extends StateNotifier<ReviewState> {
  final Ref ref;

  ReviewNotifier(this.ref) : super(const ReviewState());

  Future<void> loadProductReviews(String productId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Mock reviews for development
      await Future.delayed(const Duration(milliseconds: 500));

      final mockReviews = _getMockReviews(productId);
      final avgRating = _calculateAverageRating(mockReviews);

      state = state.copyWith(
        reviews: mockReviews,
        averageRating: avgRating,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load reviews: $e',
      );
    }
  }

  List<ReviewEntity> _getMockReviews(String productId) {
    // Different mock reviews based on product
    final allReviews = {
      'prod_1': [
        ReviewEntity(
          id: 'review_1',
          productId: 'prod_1',
          userId: 'user_456',
          userName: 'Tigist Haile',
          userImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
          rating: 5,
          comment: 'Excellent coffee! The aroma is incredible and the taste is smooth with subtle floral notes. Best Yirgacheffe I\'ve had in Addis. Highly recommend this seller!',
          helpfulCount: 12,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        ReviewEntity(
          id: 'review_2',
          productId: 'prod_1',
          userId: 'user_789',
          userName: 'Dawit Amare',
          userImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
          rating: 4,
          comment: 'Very good quality coffee. Fresh and aromatic. Delivery was fast. Only giving 4 stars because the packaging could be better.',
          helpfulCount: 8,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        ReviewEntity(
          id: 'review_3',
          productId: 'prod_1',
          userId: 'user_101',
          userName: 'Meron Tadesse',
          userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
          rating: 5,
          comment: 'I\'m a regular customer now. The coffee never disappoints. Great for traditional Ethiopian coffee ceremony.',
          helpfulCount: 15,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        ReviewEntity(
          id: 'review_4',
          productId: 'prod_1',
          userId: 'user_102',
          userName: 'Yohannes Girma',
          userImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
          rating: 4,
          comment: 'Authentic Yirgacheffe taste. Good value for money. Will order again.',
          helpfulCount: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ReviewEntity(
          id: 'review_5',
          productId: 'prod_1',
          userId: 'user_103',
          userName: 'Sara Alemayehu',
          userImage: 'https://images.unsplash.com/photo-1544005313-94ddf02805df?w=100',
          rating: 5,
          comment: 'Perfect for my morning routine. The freshness is unmatched. Arrived within 2 days in Addis.',
          helpfulCount: 7,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ],
      'prod_2': [
        ReviewEntity(
          id: 'review_6',
          productId: 'prod_2',
          userId: 'user_456',
          userName: 'Tigist Haile',
          userImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
          rating: 5,
          comment: 'Beautiful traditional Shamma! The embroidery is exquisite and the fabric quality is excellent. Perfect for special occasions.',
          helpfulCount: 20,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        ReviewEntity(
          id: 'review_7',
          productId: 'prod_2',
          userId: 'user_789',
          userName: 'Dawit Amare',
          userImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
          rating: 5,
          comment: 'Got this as a gift for my wife. She loves it! The craftsmanship is outstanding.',
          helpfulCount: 10,
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
      ],
    };

    return allReviews[productId] ?? [];
  }

  double _calculateAverageRating(List<ReviewEntity> reviews) {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  Future<void> submitReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Check if user already reviewed
      final existingReviewIndex = state.reviews.indexWhere((r) => r.userId == 'user_123');

      final newReview = ReviewEntity(
        id: 'review_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        userId: 'user_123',
        userName: 'Abebe Bikila',
        userImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        rating: rating,
        comment: comment,
        helpfulCount: 0,
        createdAt: DateTime.now(),
      );

      List<ReviewEntity> updatedReviews;
      if (existingReviewIndex >= 0) {
        // Update existing review
        updatedReviews = [...state.reviews];
        updatedReviews[existingReviewIndex] = newReview;
      } else {
        // Add new review
        updatedReviews = [newReview, ...state.reviews];
      }

      final avgRating = _calculateAverageRating(updatedReviews);

      state = state.copyWith(
        reviews: updatedReviews,
        userReview: newReview,
        averageRating: avgRating,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to submit review: $e',
      );
    }
  }

  Future<void> markHelpful(String reviewId) async {
    final updatedReviews = state.reviews.map((review) {
      if (review.id == reviewId) {
        return review.copyWith(helpfulCount: review.helpfulCount + 1);
      }
      return review;
    }).toList();

    state = state.copyWith(reviews: updatedReviews);
  }

  Future<void> deleteReview(String reviewId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedReviews = state.reviews.where((r) => r.id != reviewId).toList();
      final avgRating = _calculateAverageRating(updatedReviews);

      state = state.copyWith(
        reviews: updatedReviews,
        userReview: null,
        averageRating: avgRating,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete review: $e',
      );
    }
  }

  Future<void> loadUserReview(String productId) async {
    try {
      final userReview = state.reviews.firstWhere(
        (r) => r.productId == productId && r.userId == 'user_123',
        orElse: () => throw Exception('No user review'),
      );
      state = state.copyWith(userReview: userReview);
    } catch (e) {
      state = state.copyWith(userReview: null);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const ReviewState();
  }
}

// Providers
final reviewProvider = StateNotifierProvider<ReviewNotifier, ReviewState>((ref) {
  return ReviewNotifier(ref);
});

// Product reviews provider
final productReviewsProvider = Provider.family<List<ReviewEntity>, String>((ref, productId) {
  // This would typically trigger loading, but for now returns current state
  return ref.watch(reviewProvider).reviews;
});

// Average rating provider
final averageRatingProvider = Provider.family<double, String>((ref, productId) {
  return ref.watch(reviewProvider).averageRating;
});

// User review for product provider
final userReviewForProductProvider = Provider.family<ReviewEntity?, String>((ref, productId) {
  final state = ref.watch(reviewProvider);
  return state.reviews.firstWhere(
    (r) => r.productId == productId && r.userId == 'user_123',
    orElse: () => throw Exception('No review'),
  );
});