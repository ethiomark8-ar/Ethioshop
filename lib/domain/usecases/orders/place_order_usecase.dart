import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/core/utils/constants.dart';
import 'package:ethioshop/domain/entities/cart_item_entity.dart';
import 'package:ethioshop/domain/entities/order_entity.dart';
import 'package:ethioshop/domain/repositories/cart_repository.dart';
import 'package:ethioshop/domain/repositories/order_repository.dart';

/// Place Order Use Case
/// Domain layer - Business logic for placing an order
class PlaceOrderUseCase {
  final OrderRepository _orderRepository;
  final CartRepository _cartRepository;

  PlaceOrderUseCase(
    this._orderRepository,
    this._cartRepository,
  );

  Future<Either<Failure, OrderEntity>> call({
    required List<CartItemEntity> cartItems,
    required String shippingAddress,
    Map<String, dynamic>? paymentDetails,
  }) async {
    // Validate cart
    if (cartItems.isEmpty) {
      return const Left(Failure.validation(message: 'Cart is empty'));
    }

    // Validate shipping address
    if (shippingAddress.isEmpty) {
      return const Left(Failure.validation(message: 'Shipping address is required'));
    }

    // Calculate total
    double totalAmount = 0;
    final orderItems = <OrderItemEntity>[];

    for (final cartItem in cartItems) {
      if (cartItem.unitPrice < 0) {
        return Left(Failure.validation(
          message: 'Invalid price for ${cartItem.productTitle}',
        ));
      }

      final itemTotal = cartItem.unitPrice * cartItem.quantity;
      totalAmount += itemTotal;

      orderItems.add(OrderItemEntity(
        productId: cartItem.productId,
        productTitle: cartItem.productTitle,
        productImage: cartItem.productImage,
        quantity: cartItem.quantity,
        unitPrice: cartItem.unitPrice,
        totalPrice: itemTotal,
        variations: cartItem.variations,
      ));
    }

    if (totalAmount <= 0) {
      return const Left(Failure.validation(message: 'Invalid order total'));
    }

    // Create order
    final result = await _orderRepository.createOrder(
      items: orderItems,
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
      paymentDetails: paymentDetails,
    );

    // If order creation successful, clear cart
    return result.fold(
      (failure) => Left(failure),
      (order) async {
        final clearResult = await _cartRepository.clearCart();
        
        if (clearResult.isLeft()) {
          // Order created but cart not cleared - log error but return order
          return Right(order);
        }
        
        return Right(order);
      },
    );
  }
}