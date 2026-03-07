import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/entities/order_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_repository.freezed.dart';

/// Payment Repository Interface
/// Domain layer - Pure Dart, no dependencies on Flutter or Firebase
/// Chapa payment gateway integration
abstract class PaymentRepository {
  /// Create payment intent for Chapa checkout
  Future<Either<Failure, PaymentIntent>> createPaymentIntent({
    required double amount, // In ETB
    required String orderId,
    required String email,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    String? callbackUrl,
  });

  /// Verify payment after Chapa callback
  Future<Either<Failure, PaymentVerification>> verifyPayment({
    required String transactionId,
    required String orderId,
  });

  /// Get payment status
  Future<Either<Failure, PaymentStatus>> getPaymentStatus(String transactionId);

  /// Process refund
  Future<Either<Failure, void>> processRefund({
    required String transactionId,
    required double amount,
    String? reason,
  });

  /// Release escrow funds to seller
  Future<Either<Failure, void>> releaseEscrowFunds({
    required String orderId,
    required String sellerId,
    required double amount,
  });

  /// Get payment methods available
  Future<Either<Failure, List<PaymentMethod>>> getAvailablePaymentMethods();

  /// Calculate order total with fees
  Future<Either<Failure, OrderTotal>> calculateOrderTotal({
    required double subtotal,
    String? shippingMethod,
  });

  /// Validate payment details
  Future<Either<Failure, void>> validatePaymentDetails({
    required String email,
    required String phoneNumber,
  });
}

@freezed
class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    required String checkoutUrl,
    required String transactionId,
    required double amount,
    required String currency,
    required DateTime expiresAt,
  }) = _PaymentIntent;
}

@freezed
class PaymentVerification with _$PaymentVerification {
  const factory PaymentVerification({
    required bool isSuccess,
    required String transactionId,
    required PaymentStatus status,
    required double amount,
    required String currency,
    String? errorMessage,
    DateTime? processedAt,
  }) = _PaymentVerification;
}

enum PaymentStatus {
  pending,
  processing,
  success,
  failed,
  cancelled,
  refunded,
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.cancelled:
        return 'Cancelled';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  bool get isCompleted => this == PaymentStatus.success || this == PaymentStatus.refunded;
  bool get isActive => !isCompleted && this != PaymentStatus.cancelled;
  bool get isSuccessful => this == PaymentStatus.success;
}

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required String name,
    required String displayName,
    required String icon,
    bool isEnabled,
    double? transactionFee,
  }) = _PaymentMethod;
}

@freezed
class OrderTotal with _$OrderTotal {
  const factory OrderTotal({
    required double subtotal,
    required double shipping,
    required double tax,
    required double serviceFee,
    required double total,
    String? currency,
  }) = _OrderTotal;
}