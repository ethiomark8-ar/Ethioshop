import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ethioshop/domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Product Model - Data layer representation for serialization
/// Converts between Firestore documents and Domain entities
@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String category,
    required List<String> imageUrls,
    required List<String> thumbnailUrls,
    required String sellerId,
    required String sellerName,
    @JsonKey(defaultValue: 0.0) double averageRating,
    @JsonKey(defaultValue: 0) int totalRatings,
    required DateTime createdAt,
    @JsonKey(defaultValue: 0) int stockCount,
    ProductLocationModel? location,
    @JsonKey(defaultValue: true) bool isActive,
    @JsonKey(defaultValue: false) bool isFeatured,
    String? brand,
    List<String>? tags,
    Map<String, dynamic>? specifications,
    DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in document
    return json;
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      description: description,
      price: price,
      category: category,
      imageUrls: imageUrls,
      thumbnailUrls: thumbnailUrls,
      sellerId: sellerId,
      sellerName: sellerName,
      averageRating: averageRating,
      totalRatings: totalRatings,
      createdAt: createdAt,
      stockCount: stockCount,
      location: location?.toEntity(),
      isActive: isActive,
      isFeatured: isFeatured,
      brand: brand,
      tags: tags,
      specifications: specifications,
    );
  }
}

@freezed
class ProductLocationModel with _$ProductLocationModel {
  const factory ProductLocationModel({
    required double latitude,
    required double longitude,
    String? address,
    String? city,
  }) = _ProductLocationModel;

  factory ProductLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ProductLocationModelFromJson(json);

  ProductLocation toEntity() {
    return ProductLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
      city: city,
    );
  }
}