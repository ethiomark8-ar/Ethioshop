import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final List<String> imageUrls;
  final bool verifiedPurchase;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.imageUrls = const [],
    this.verifiedPurchase = false,
    this.helpfulCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        userId,
        userName,
        userAvatar,
        rating,
        comment,
        imageUrls,
        verifiedPurchase,
        helpfulCount,
        createdAt,
        updatedAt,
  ];

  ReviewEntity copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userAvatar,
    double? rating,
    String? comment,
    List<String>? imageUrls,
    bool? verifiedPurchase,
    int? helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      imageUrls: imageUrls ?? this.imageUrls,
      verifiedPurchase: verifiedPurchase ?? this.verifiedPurchase,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}