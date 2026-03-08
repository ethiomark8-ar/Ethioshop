import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String name;
  final String description;
  final String image;
  final double price;
  final int quantity;
  final String category;
  final int availableStock;
  final String sellerId;
  final String sellerName;

  const CartItemEntity({
    required this.productId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
    required this.category,
    required this.availableStock,
    required this.sellerId,
    required this.sellerName,
  });

  double get total => price * quantity;
  bool get isAvailable => availableStock > 0;
  bool get isOutOfStock => availableStock == 0;

  @override
  List<Object?> get props => [
        productId,
        name,
        description,
        image,
        price,
        quantity,
        category,
        availableStock,
        sellerId,
        sellerName,
      ];

  CartItemEntity copyWith({
    String? productId,
    String? name,
    String? description,
    String? image,
    double? price,
    int? quantity,
    String? category,
    int? availableStock,
    String? sellerId,
    String? sellerName,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      availableStock: availableStock ?? this.availableStock,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
    );
  }
}