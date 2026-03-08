import 'package:dartz/dartz.dart';
import '../entities/review_entity.dart';
import '../failures/failure.dart';

abstract class ReviewRepository {
  // Review Operations
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews({
    required String productId,
    int? limit,
    String? lastReviewId,
  });

  Future<Either<Failure, ReviewEntity>> createReview({
    required String productId,
    required double rating,
    required String comment,
    List<String>? imageUrls,
  });

  Future<Either<Failure, ReviewEntity>> updateReview({
    required String reviewId,
    double? rating,
    String? comment,
    List<String>? imageUrls,
  });

  Future<Either<Failure, void>> deleteReview(String reviewId);

  // Helpful Votes
  Future<Either<Failure, void>> markReviewHelpful(String reviewId);

  Future<Either<Failure, void>> unmarkReviewHelpful(String reviewId);

  // User Reviews
  Future<Either<Failure, List<ReviewEntity>>> getUserReviews({
    required String userId,
  });

  // Statistics
  Future<Either<Failure, Map<String, dynamic>>> getProductReviewStats({
    required String productId,
  });

  // Streams
  Stream<List<ReviewEntity>> watchProductReviews(String productId);
}