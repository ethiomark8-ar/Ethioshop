import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/api_constants.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  late final Box<CartItemEntity> _cartBox;

  CartRepositoryImpl() {
    _cartBox = Hive.box<CartItemEntity>(ApiConstants.offlineCartKey);
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = _cartBox.values.toList();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final existingItem = _cartBox.get(productId);
      
      if (existingItem != null) {
        final newQuantity = existingItem.quantity + quantity;
        final updatedItem = existingItem.copyWith(quantity: newQuantity);
        await _cartBox.put(productId, updatedItem);
        return Right(updatedItem);
      }

      final newItem = CartItemEntity(
        productId: productId,
        name: name,
        description: description,
        image: image,
        price: price,
        quantity: quantity,
        category: category,
        availableStock: availableStock,
        sellerId: sellerId,
        sellerName: sellerName,
      );

      await _cartBox.put(productId, newItem);
      return Right(newItem);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    try {
      final existingItem = _cartBox.get(productId);
      if (existingItem == null) {
        return const Left(NotFoundFailure(message: 'Item not in cart'));
      }

      if (quantity <= 0) {
        await _cartBox.delete(productId);
        return Right(existingItem.copyWith(quantity: 0));
      }

      final updatedItem = existingItem.copyWith(quantity: quantity);
      await _cartBox.put(productId, updatedItem);
      return Right(updatedItem);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    try {
      await _cartBox.delete(productId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _cartBox.clear();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  double get cartTotal {
    return _cartBox.values.fold(0.0, (sum, item) => sum + item.total);
  }

  @override
  int get cartItemCount {
    return _cartBox.values.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Future<Either<Failure, void>> syncCartWithServer() async {
    // TODO: Implement sync with Firestore
    return const Right(null);
  }

  @override
  Stream<List<CartItemEntity>> get cartStream {
    return _cartBox.watch().map((_) => _cartBox.values.toList());
  }
}