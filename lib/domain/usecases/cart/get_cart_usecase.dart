import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/entities/cart_item_entity.dart';
import 'package:ethioshop/domain/repositories/cart_repository.dart';

/// Get Cart Use Case
/// Domain layer - Business logic for retrieving cart items
class GetCartUseCase {
  final CartRepository _cartRepository;

  GetCartUseCase(this._cartRepository);

  Future<Either<Failure, List<CartItemEntity>>> call() async {
    // Call repository
    return await _cartRepository.getCartItems();
  }

  Future<Either<Failure, CartSummary>> getCartSummary() async {
    // Call repository
    return await _cartRepository.getCartSummary();
  }

  Stream<Either<Failure, List<CartItemEntity>>> watchCart() {
    // Call repository stream
    return _cartRepository.watchCart();
  }
}