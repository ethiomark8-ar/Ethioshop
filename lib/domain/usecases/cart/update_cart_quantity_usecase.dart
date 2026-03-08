import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/core/utils/constants.dart';
import 'package:ethioshop/domain/entities/cart_item_entity.dart';
import 'package:ethioshop/domain/repositories/cart_repository.dart';

/// Update Cart Quantity Use Case
/// Domain layer - Business logic for updating cart item quantity
class UpdateCartQuantityUseCase {
  final CartRepository _cartRepository;

  UpdateCartQuantityUseCase(this._cartRepository);

  Future<Either<Failure, CartItemEntity>> call({
    required String productId,
    required int quantity,
  }) async {
    // Validate input
    if (productId.isEmpty) {
      return const Left(Failure.validation(message: 'Product ID is required'));
    }

    if (quantity < 0) {
      return const Left(Failure.validation(message: 'Quantity cannot be negative'));
    }

    if (quantity > AppConstants.maxCartQuantity) {
      return Left(Failure.validation(
        message: 'Maximum quantity per item is ${AppConstants.maxCartQuantity}',
      ));
    }

    // Call repository
    return await _cartRepository.updateQuantity(
      productId: productId,
      quantity: quantity,
    );
  }
}