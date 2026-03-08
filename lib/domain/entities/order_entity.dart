import 'package:equatable/equatable.dart';
import 'product_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final String phoneNumber;
  final String paymentMethod;
  final String? paymentReference;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? estimatedDeliveryDate;
  final DateTime? deliveredAt;
  final String? trackingNumber;
  final String? deliveryAgentName;
  final String? deliveryAgentPhone;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.phoneNumber,
    required this.paymentMethod,
    this.paymentReference,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.estimatedDeliveryDate,
    this.deliveredAt,
    this.trackingNumber,
    this.deliveryAgentName,
    this.deliveryAgentPhone,
  });

  bool get isDelivered => status == OrderStatus.delivered;
  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isPending => status == OrderStatus.pending;
  bool get canCancel => status == OrderStatus.pending ||
                         status == OrderStatus.confirmed;

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        subtotal,
        deliveryFee,
        total,
        deliveryAddress,
        deliveryInstructions,
        phoneNumber,
        paymentMethod,
        paymentReference,
        status,
        createdAt,
        updatedAt,
        estimatedDeliveryDate,
        deliveredAt,
        trackingNumber,
        deliveryAgentName,
        deliveryAgentPhone,
      ];
}

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String? variant;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.variant,
  });

  double get total => price * quantity;

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImage,
        price,
        quantity,
        variant,
      ];
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  int get orderIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.processing:
        return 2;
      case OrderStatus.shipped:
        return 3;
      case OrderStatus.outForDelivery:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
        return -1;
      case OrderStatus.returned:
        return -1;
    }
  }
}