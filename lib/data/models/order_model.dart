import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ethioshop/domain/entities/order_entity.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// Order Model - Data layer representation for serialization
/// Converts between Firestore documents and Domain entities
@freezed
class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    required String id,
    required String buyerId,
    required String sellerId,
    required List<OrderItemModel> items,
    required double totalAmount,
    required String status,
    required DateTime createdAt,
    DateTime? confirmedAt,
    DateTime? shippedAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? shippingAddress,
    String? paymentReference,
    String? chapaTransactionId,
    String? cancellationReason,
    Map<String, dynamic>? paymentDetails,
    String? trackingNumber,
    DateTime? updatedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in document
    return json;
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      buyerId: buyerId,
      sellerId: sellerId,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => OrderStatus.pending,
      ),
      createdAt: createdAt,
      confirmedAt: confirmedAt,
      shippedAt: shippedAt,
      deliveredAt: deliveredAt,
      cancelledAt: cancelledAt,
      shippingAddress: shippingAddress,
      paymentReference: paymentReference,
      chapaTransactionId: chapaTransactionId,
      cancellationReason: cancellationReason,
      paymentDetails: paymentDetails,
      trackingNumber: trackingNumber,
    );
  }
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String productId,
    required String productTitle,
    required String productImage,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    Map<String, dynamic>? variations,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      productTitle: productTitle,
      productImage: productImage,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      variations: variations,
    );
  }
}