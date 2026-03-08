import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final String sellerId;
  final String sellerName;
  final String? sellerAvatar;
  final int stock;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final bool isFeatured;
  final bool isActive;
  final List<String> tags;
  final String? location;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar,
    required this.stock,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.soldCount = 0,
    this.isFeatured = false,
    this.isActive = true,
    this.tags = const [],
    this.location,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 5;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        category,
        imageUrls,
        sellerId,
        sellerName,
        sellerAvatar,
        stock,
        rating,
        reviewCount,
        soldCount,
        isFeatured,
        isActive,
        tags,
        location,
        createdAt,
        updatedAt,
      ];

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? imageUrls,
    String? sellerId,
    String? sellerName,
    String? sellerAvatar,
    int? stock,
    double? rating,
    int? reviewCount,
    int? soldCount,
    bool? isFeatured,
    bool? isActive,
    List<String>? tags,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      soldCount: soldCount ?? this.soldCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}