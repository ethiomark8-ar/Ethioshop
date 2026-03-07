import 'package:dartz/dartz.dart';
import '../entities/cart_item_entity.dart';
import '../failures/failure.dart';

abstract class CartRepository {
  // Cart Operations
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();

  Future<Either<Failure, CartItemEntity>> addToCart({
    required String productId,
    required String name,
    required String description,
    required String image,
    required double price,
    required String category,
    required int availableStock,
    required String sellerId,
    required String sellerName,
    int quantity = 1,
  });

  Future<Either<Failure, CartItemEntity>> updateCartItemQuantity({
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, void>> removeFromCart(String productId);

  Future<Either<Failure, void>> clearCart();

  // Cart Calculations
  double get cartTotal;
  int get cartItemCount;

  // Sync
  Future<Either<Failure, void>> syncCartWithServer();

  // Streams
  Stream<List<CartItemEntity>> get cartStream;
}