import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/data/datasources/firebase/order_firebase_datasource.dart';
import 'package:ethioshop/data/models/order_model.dart';
import 'package:ethioshop/domain/entities/order_entity.dart';
import 'package:ethioshop/domain/repositories/order_repository.dart';

/// Order Repository Implementation
/// Data layer - Implements domain interface using Firebase datasource
class OrderRepositoryImpl implements OrderRepository {
  final OrderFirebaseDatasource _orderDatasource;

  OrderRepositoryImpl(this._orderDatasource);

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemEntity> items,
    required double totalAmount,
    required String shippingAddress,
    Map<String, dynamic>? paymentDetails,
  }) async {
    try {
      // Get current user ID (would come from auth repository in real implementation)
      // For now, this is a placeholder
      final buyerId = 'current_user_id'; 
      
      // Get seller ID from first item (simplified - in real app, handle multiple sellers)
      final sellerId = items.first.sellerId;

      final orderData = {
        'buyerId': buyerId,
        'sellerId': sellerId,
        'items': items.map((item) => OrderItemModel(
          productId: item.productId,
          productTitle: item.productTitle,
          productImage: item.productImage,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          totalPrice: item.totalPrice,
          variations: item.variations,
        ).toJson()).toList(),
        'totalAmount': totalAmount,
        'status': OrderStatus.pending.name,
        'shippingAddress': shippingAddress,
        'paymentDetails': paymentDetails ?? {},
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      final docRef = await _orderDatasource.createOrder(orderData);
      
      final updatedData = {...orderData, 'id': docRef.id};
      final orderModel = OrderModel.fromJson(updatedData);
      
      return Right(orderModel.toEntity());
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final docSnapshot = await _orderDatasource.getOrderById(orderId);

      if (!docSnapshot.exists) {
        return Left(Failure.server(message: 'Order not found', statusCode: 404));
      }

      final order = OrderModel.fromFirestore(docSnapshot).toEntity();
      return Right(order);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getBuyerOrders({
    required String buyerId,
    OrderStatus? status,
    int? limit,
  }) async {
    try {
      final querySnapshot = await _orderDatasource.getBuyerOrders(
        buyerId: buyerId,
        status: status,
        limit: limit,
      );

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc).toEntity())
          .toList();

      return Right(orders);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getSellerOrders({
    required String sellerId,
    OrderStatus? status,
    int? limit,
  }) async {
    try {
      final querySnapshot = await _orderDatasource.getSellerOrders(
        sellerId: sellerId,
        status: status,
        limit: limit,
      );

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc).toEntity())
          .toList();

      return Right(orders);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? cancellationReason,
  }) async {
    try {
      await _orderDatasource.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
      );

      if (newStatus == OrderStatus.cancelled && cancellationReason != null) {
        await _orderDatasource.cancelOrder(
          orderId: orderId,
          reason: cancellationReason,
        );
      }

      final docSnapshot = await _orderDatasource.getOrderById(orderId);
      final order = OrderModel.fromFirestore(docSnapshot).toEntity();

      return Right(order);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder({
    required String orderId,
    String? reason,
  }) async {
    try {
      return await updateOrderStatus(
        orderId: orderId,
        newStatus: OrderStatus.cancelled,
        cancellationReason: reason,
      );
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, OrderEntity>> watchOrder(String orderId) {
    return _orderDatasource.watchOrder(orderId).map((snapshot) {
      try {
        if (!snapshot.exists) {
          return Left(Failure.server(message: 'Order not found', statusCode: 404));
        }

        final order = OrderModel.fromFirestore(snapshot).toEntity();
        return Right(order);
      } catch (e) {
        return Left(Failure.unknown(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, OrderStatistics>> getSellerOrderStatistics(
    String sellerId,
  ) async {
    try {
      final statsMap = await _orderDatasource.getSellerOrderStatistics(sellerId);

      final stats = OrderStatistics(
        totalOrders: statsMap['totalOrders'] as int,
        pendingOrders: statsMap['pendingOrders'] as int,
        confirmedOrders: statsMap['confirmedOrders'] as int,
        shippedOrders: statsMap['shippedOrders'] as int,
        deliveredOrders: statsMap['deliveredOrders'] as int,
        cancelledOrders: statsMap['cancelledOrders'] as int,
        totalRevenue: (statsMap['totalRevenue'] as num).toDouble(),
        averageOrderValue: (statsMap['averageOrderValue'] as num).toDouble(),
      );

      return Right(stats);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderStatistics>> getAdminOrderStatistics() async {
    try {
      final statsMap = await _orderDatasource.getAdminOrderStatistics();

      final stats = OrderStatistics(
        totalOrders: statsMap['totalOrders'] as int,
        pendingOrders: statsMap['pendingOrders'] as int,
        confirmedOrders: statsMap['confirmedOrders'] as int,
        shippedOrders: statsMap['shippedOrders'] as int,
        deliveredOrders: statsMap['deliveredOrders'] as int,
        cancelledOrders: statsMap['cancelledOrders'] as int,
        totalRevenue: (statsMap['totalRevenue'] as num).toDouble(),
        averageOrderValue: (statsMap['averageOrderValue'] as num).toDouble(),
      );

      return Right(stats);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}