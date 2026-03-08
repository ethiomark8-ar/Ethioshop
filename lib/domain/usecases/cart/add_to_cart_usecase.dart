import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/core/utils/constants.dart';
import 'package:ethioshop/domain/entities/cart_item_entity.dart';
import 'package:ethioshop/domain/repositories/cart_repository.dart';

/// Add to Cart Use Case
/// Domain layer - Business logic for adding items to cart
class AddToCartUseCase {
  final CartRepository _cartRepository;

  AddToCartUseCase(this._cartRepository);

  Future<Either<Failure, CartItemEntity>> call(CartItemEntity item) async {
    // Validate product data
    if (item.productId.isEmpty) {
      return const Left(Failure.validation(message: 'Product ID is required'));
    }

    if (item.productTitle.isEmpty) {
      return const Left(Failure.validation(message: 'Product title is required'));
    }

    if (item.unitPrice < 0) {
      return const Left(Failure.validation(message: 'Invalid price'));
    }

    if (item.quantity <= 0) {
      return const Left(Failure.validation(message: 'Quantity must be greater than 0'));
    }

    if (item.quantity > AppConstants.maxCartQuantity) {
      return Left(Failure.validation(
        message: 'Maximum quantity per item is ${AppConstants.maxCartQuantity}',
      ));
    }

    if (item.sellerId.isEmpty) {
      return const Left(Failure.validation(message: 'Seller ID is required'));
    }

    // Call repository
    return await _cartRepository.addToCart(item);
  }
}