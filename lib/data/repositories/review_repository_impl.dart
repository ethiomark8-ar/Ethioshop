import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/data/datasources/firebase/review_firebase_datasource.dart';
import 'package:ethioshop/data/models/review_model.dart';
import 'package:ethioshop/domain/entities/review_entity.dart';
import 'package:ethioshop/domain/repositories/review_repository.dart';
import 'dart:io';

/// Review Repository Implementation
/// Data layer - Implements domain interface using Firebase datasource
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewFirebaseDatasource _reviewDatasource;

  // Current user ID - would be injected from auth repository
  String? _currentUserId;

  ReviewRepositoryImpl(this._reviewDatasource);

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  String get _userId => _currentUserId ?? '';

  @override
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews({
    required String productId,
    int? limit,
  }) async {
    try {
      final querySnapshot = await _reviewDatasource.getProductReviews(
        productId: productId,
        limit: limit ?? 20,
      );

      final reviews = querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc).toEntity())
          .toList();

      return Right(reviews);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getUserReviews({
    required String userId,
    int? limit,
  }) async {
    try {
      final querySnapshot = await _reviewDatasource.getUserReviews(
        userId: userId,
        limit: limit,
      );

      final reviews = querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc).toEntity())
          .toList();

      return Right(reviews);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String productId,
    required String orderId,
    required int rating,
    required String comment,
    List<String>? imageUrls,
  }) async {
    try {
      // Validate rating
      if (rating < AppConstants.minReviewRating || rating > AppConstants.maxReviewRating) {
        return Left(Failure.validation(message: 'Invalid rating value'));
      }

      // Check if user can review this product
      final canReview = await _reviewDatasource.canReviewProduct(
        productId: productId,
        userId: _userId,
      );

      if (!canReview) {
        return Left(Failure.validation(
          message: 'You can only review products you have purchased and received',
        ));
      }

      // Get user details (simplified - would come from auth repository)
      final docRef = await _reviewDatasource.submitReview(
        productId: productId,
        orderId: orderId,
        reviewerId: _userId,
        reviewerName: 'User Name', // Would fetch from user document
        reviewerAvatar: '', // Would fetch from user document
        rating: rating,
        comment: comment,
        imageUrls: imageUrls ?? [],
      );

      final reviewData = {
        'id': docRef.id,
        'productId': productId,
        'orderId': orderId,
        'reviewerId': _userId,
        'reviewerName': 'User Name',
        'reviewerAvatar': '',
        'rating': rating,
        'comment': comment,
        'imageUrls': imageUrls ?? [],
        'isVerifiedPurchase': true,
        'helpfulCount': 0,
        'createdAt': DateTime.now(),
      };

      final reviewModel = ReviewModel.fromJson(reviewData);
      return Right(reviewModel.toEntity());
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
    List<String>? imageUrls,
  }) async {
    try {
      if (rating != null) {
        if (rating < AppConstants.minReviewRating || rating > AppConstants.maxReviewRating) {
          return Left(Failure.validation(message: 'Invalid rating value'));
        }
      }

      await _reviewDatasource.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
        imageUrls: imageUrls,
      );

      // In a real implementation, fetch the updated review
      // For now, return a placeholder
      return Left(Failure.unknown(message: 'Implementation needed'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      await _reviewDatasource.deleteReview(reviewId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markReviewHelpful(String reviewId) async {
    try {
      await _reviewDatasource.markReviewHelpful(reviewId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> canReviewProduct({
    required String productId,
    required String userId,
  }) async {
    try {
      final canReview = await _reviewDatasource.canReviewProduct(
        productId: productId,
        userId: userId,
      );
      return Right(canReview);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity?>> getUserProductReview({
    required String productId,
    required String userId,
  }) async {
    try {
      final docSnapshot = await _reviewDatasource.getUserProductReview(
        productId: productId,
        userId: userId,
      );

      if (docSnapshot == null || !docSnapshot.exists) {
        return const Right(null);
      }

      final review = ReviewModel.fromFirestore(docSnapshot).toEntity();
      return Right(review);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductRatingSummary>> getProductRatingSummary(
    String productId,
  ) async {
    try {
      final summaryMap = await _reviewDatasource.getProductRatingSummary(productId);

      final summary = ProductRatingSummary(
        averageRating: (summaryMap['averageRating'] as num).toDouble(),
        totalReviews: summaryMap['totalReviews'] as int,
        fiveStarCount: summaryMap['fiveStarCount'] as int,
        fourStarCount: summaryMap['fourStarCount'] as int,
        threeStarCount: summaryMap['threeStarCount'] as int,
        twoStarCount: summaryMap['twoStarCount'] as int,
        oneStarCount: summaryMap['oneStarCount'] as int,
      );

      return Right(summary);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ReviewEntity>>> watchProductReviews(String productId) {
    return _reviewDatasource.watchProductReviews(productId).map((snapshot) {
      try {
        final reviews = snapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc).toEntity())
            .toList();
        return Right(reviews);
      } catch (e) {
        return Left(Failure.unknown(message: e.toString()));
      }
    });
  }
}