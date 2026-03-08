import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../failures/failure.dart';

abstract class OrderRepository {
  // Order Operations
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);

  Future<Either<Failure, List<OrderEntity>>> getUserOrders({
    required String userId,
    OrderStatus? status,
    int? limit,
  });

  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemEntity> items,
    required String deliveryAddress,
    String? deliveryInstructions,
    required String phoneNumber,
    required String paymentMethod,
    required double subtotal,
    required double deliveryFee,
    required double total,
  });

  Future<Either<Failure, void>> cancelOrder(String orderId);

  Future<Either<Failure, void>> returnOrder({
    required String orderId,
    required String reason,
  });

  // Admin Operations
  Future<Either<Failure, List<OrderEntity>>> getAllOrders({
    OrderStatus? status,
    int? limit,
  });

  Future<Either<Failure, OrderEntity>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? trackingNumber,
    String? deliveryAgentName,
    String? deliveryAgentPhone,
  });

  // Statistics
  Future<Either<Failure, Map<String, dynamic>>> getOrderStatistics({
    required String userId,
  });

  // Payment
  Future<Either<Failure, String>> initiatePayment({
    required String orderId,
    required double amount,
    required String email,
    required String phoneNumber,
    required String returnUrl,
  });

  Future<Either<Failure, bool>> verifyPayment({
    required String transactionId,
  });

  // Streams
  Stream<List<OrderEntity>> watchUserOrders(String userId);
  Stream<OrderEntity?> watchOrder(String orderId);
}