import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ethioshop/domain/entities/review_entity.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

/// Review Model - Data layer representation for serialization
/// Converts between Firestore documents and Domain entities
@freezed
class ReviewModel with _$ReviewModel {
  const ReviewModel._();

  const factory ReviewModel({
    required String id,
    required String productId,
    required String orderId,
    required String reviewerId,
    required String reviewerName,
    required String reviewerAvatar,
    required int rating,
    required String comment,
    required DateTime createdAt,
    @JsonKey(defaultValue: []) List<String> imageUrls,
    @JsonKey(defaultValue: true) bool isVerifiedPurchase,
    @JsonKey(defaultValue: 0) int helpfulCount,
    DateTime? updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in document
    return json;
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      productId: productId,
      orderId: orderId,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      reviewerAvatar: reviewerAvatar,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      imageUrls: imageUrls,
      isVerifiedPurchase: isVerifiedPurchase,
      helpfulCount: helpfulCount,
    );
  }
}