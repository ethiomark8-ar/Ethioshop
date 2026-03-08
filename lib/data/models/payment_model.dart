import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ethioshop/domain/repositories/payment_repository.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Payment Model - Data layer representation for serialization
/// Converts between Firestore documents and Domain entities
@freezed
class PaymentModel with _$PaymentModel {
  const PaymentModel._();

  const factory PaymentModel({
    required String transactionId,
    required String orderId,
    required double amount,
    required String currency,
    required String status,
    required String paymentMethod,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? processedAt,
    String? errorMessage,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? paymentDetails,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel.fromJson(data).copyWith(
      transactionId: doc.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('transactionId'); // Don't store as field, it's the doc ID
    return json;
  }

  PaymentVerification toVerificationEntity() {
    return PaymentVerification(
      isSuccess: status == PaymentStatus.success.name,
      transactionId: transactionId,
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => PaymentStatus.pending,
      ),
      amount: amount,
      currency: currency,
      errorMessage: errorMessage,
      processedAt: processedAt,
    );
  }
}

@freezed
class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    required String id,
    required String name,
    required String displayName,
    required String icon,
    @JsonKey(defaultValue: true) bool isEnabled,
    double? transactionFee,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  PaymentMethod toEntity() {
    return PaymentMethod(
      id: id,
      name: name,
      displayName: displayName,
      icon: icon,
      isEnabled: isEnabled,
      transactionFee: transactionFee,
    );
  }
}

@freezed
class OrderTotalModel with _$OrderTotalModel {
  const factory OrderTotalModel({
    required double subtotal,
    required double shipping,
    required double tax,
    required double serviceFee,
    required double total,
    String? currency,
  }) = _OrderTotalModel;

  factory OrderTotalModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTotalModelFromJson(json);

  OrderTotal toEntity() {
    return OrderTotal(
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      serviceFee: serviceFee,
      total: total,
      currency: currency ?? 'ETB',
    );
  }
}