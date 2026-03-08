import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

/// Firebase Review Datasource
/// Data layer - Handles all review-related Firebase operations
class ReviewFirebaseDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ReviewFirebaseDatasource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  CollectionReference get _reviewsCollection =>
      _firestore.collection('reviews');

  CollectionReference get _productsCollection =>
      _firestore.collection('products');

  /// Get reviews for a product
  Future<QuerySnapshot> getProductReviews({
    required String productId,
    int? limit,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _reviewsCollection
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.get();
  }

  /// Get reviews by user
  Future<QuerySnapshot> getUserReviews({
    required String userId,
    int? limit,
  }) async {
    Query query = _reviewsCollection
        .where('reviewerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query.get();
  }

  /// Submit review
  Future<DocumentReference> submitReview({
    required String productId,
    required String orderId,
    required String reviewerId,
    required String reviewerName,
    required String reviewerAvatar,
    required int rating,
    required String comment,
    List<String>? imageUrls,
  }) async {
    final docRef = await _reviewsCollection.add({
      'productId': productId,
      'orderId': orderId,
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'reviewerAvatar': reviewerAvatar,
      'rating': rating,
      'comment': comment,
      'imageUrls': imageUrls ?? [],
      'isVerifiedPurchase': true,
      'helpfulCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Update product rating
    await _updateProductRating(productId);

    return docRef;
  }

  /// Update review
  Future<void> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
    List<String>? imageUrls,
  }) async {
    final Map<String, dynamic> data = {};
    if (rating != null) data['rating'] = rating;
    if (comment != null) data['comment'] = comment;
    if (imageUrls != null) data['imageUrls'] = imageUrls;
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _reviewsCollection.doc(reviewId).update(data);

    // Update product rating
    final review = await _reviewsCollection.doc(reviewId).get();
    final productId = review.get('productId');
    await _updateProductRating(productId);
  }

  /// Delete review
  Future<void> deleteReview(String reviewId) async {
    final review = await _reviewsCollection.doc(reviewId).get();
    final productId = review.get('productId');

    await _reviewsCollection.doc(reviewId).delete();

    // Update product rating
    await _updateProductRating(productId);
  }

  /// Mark review as helpful
  Future<void> markReviewHelpful(String reviewId) async {
    await _reviewsCollection.doc(reviewId).update({
      'helpfulCount': FieldValue.increment(1),
    });
  }

  /// Check if user can review product
  Future<bool> canReviewProduct({
    required String productId,
    required String userId,
  }) async {
    // Check if user has a delivered order for this product
    final orders = await _firestore
        .collection('orders')
        .where('buyerId', isEqualTo: userId)
        .where('status', isEqualTo: 'delivered')
        .get();

    for (final order in orders.docs) {
      final items = order.get('items') as List;
      for (final item in items) {
        if (item['productId'] == productId) {
          // Check if already reviewed
          final existingReview = await _reviewsCollection
              .where('productId', isEqualTo: productId)
              .where('reviewerId', isEqualTo: userId)
              .where('orderId', isEqualTo: order.id)
              .get();

          if (existingReview.isEmpty) {
            return true;
          }
        }
      }
    }

    return false;
  }

  /// Get user's review for a product
  Future<DocumentSnapshot?> getUserProductReview({
    required String productId,
    required String userId,
  }) async {
    final query = await _reviewsCollection
        .where('productId', isEqualTo: productId)
        .where('reviewerId', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return query.docs.first;
  }

  /// Get product rating summary
  Future<Map<String, dynamic>> getProductRatingSummary(
    String productId,
  ) async {
    final reviews = await _reviewsCollection
        .where('productId', isEqualTo: productId)
        .get();

    if (reviews.isEmpty) {
      return {
        'averageRating': 0.0,
        'totalReviews': 0,
        'fiveStarCount': 0,
        'fourStarCount': 0,
        'threeStarCount': 0,
        'twoStarCount': 0,
        'oneStarCount': 0,
      };
    }

    double totalRating = 0;
    int fiveStarCount = 0;
    int fourStarCount = 0;
    int threeStarCount = 0;
    int twoStarCount = 0;
    int oneStarCount = 0;

    for (final doc in reviews.docs) {
      final rating = doc.get('rating') as int;
      totalRating += rating;

      switch (rating) {
        case 5:
          fiveStarCount++;
          break;
        case 4:
          fourStarCount++;
          break;
        case 3:
          threeStarCount++;
          break;
        case 2:
          twoStarCount++;
          break;
        case 1:
          oneStarCount++;
          break;
      }
    }

    return {
      'averageRating': totalRating / reviews.size,
      'totalReviews': reviews.size,
      'fiveStarCount': fiveStarCount,
      'fourStarCount': fourStarCount,
      'threeStarCount': threeStarCount,
      'twoStarCount': twoStarCount,
      'oneStarCount': oneStarCount,
    };
  }

  /// Stream reviews for a product
  Stream<QuerySnapshot> watchProductReviews(String productId) {
    return _reviewsCollection
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Upload review images
  Future<List<String>> uploadReviewImages({
    required List<File> images,
    required String reviewId,
  }) async {
    final List<String> imageUrls = [];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      final fileName = 'reviews/$reviewId/$timestamp_$i.jpg';

      try {
        final ref = _storage.ref().child(fileName);
        final uploadTask = ref.putFile(image);

        await uploadTask;

        final downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        throw Exception('Failed to upload review image: ${e.toString()}');
      }
    }

    return imageUrls;
  }

  /// Update product rating in product document
  Future<void> _updateProductRating(String productId) async {
    final summary = await getProductRatingSummary(productId);

    await _productsCollection.doc(productId).update({
      'averageRating': summary['averageRating'],
      'totalRatings': summary['totalReviews'],
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}