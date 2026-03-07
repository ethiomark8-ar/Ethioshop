import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/core/utils/constants.dart';
import 'package:ethioshop/data/datasources/firebase/payment_firebase_datasource.dart';
import 'package:ethioshop/data/models/payment_model.dart';
import 'package:ethioshop/domain/repositories/payment_repository.dart';

/// Payment Repository Implementation
/// Data layer - Implements domain interface using Firebase datasource
/// Integrates with Chapa payment gateway
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentFirebaseDatasource _paymentDatasource;

  PaymentRepositoryImpl(this._paymentDatasource);

  @override
  Future<Either<Failure, PaymentIntent>> createPaymentIntent({
    required double amount,
    required String orderId,
    required String email,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    String? callbackUrl,
  }) async {
    try {
      // Validate amount
      if (amount <= 0) {
        return Left(Failure.validation(message: 'Invalid amount'));
      }

      // Validate email and phone
      final validation = await validatePaymentDetails(
        email: email,
        phoneNumber: phoneNumber,
      );
      
      if (validation.isLeft()) {
        return validation.fold((l) => Left(l), (r) => const Right(null));
      }

      final result = await _paymentDatasource.createPaymentIntent(
        amount: amount,
        orderId: orderId,
        email: email,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        callbackUrl: callbackUrl,
      );

      final intent = PaymentIntent(
        checkoutUrl: result['checkoutUrl'] as String,
        transactionId: result['transactionId'] as String,
        amount: (result['amount'] as num).toDouble(),
        currency: result['currency'] as String? ?? AppConstants.currencyCode,
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      );

      return Right(intent);
    } catch (e) {
      return Left(Failure.payment(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentVerification>> verifyPayment({
    required String transactionId,
    required String orderId,
  }) async {
    try {
      final result = await _paymentDatasource.verifyPayment(
        transactionId: transactionId,
        orderId: orderId,
      );

      final verification = PaymentVerification(
        isSuccess: result['isSuccess'] as bool,
        transactionId: result['transactionId'] as String,
        status: PaymentStatus.values.firstWhere(
          (e) => e.name == result['status'],
          orElse: () => PaymentStatus.pending,
        ),
        amount: (result['amount'] as num).toDouble(),
        currency: result['currency'] as String? ?? AppConstants.currencyCode,
        errorMessage: result['errorMessage'] as String?,
        processedAt: result['processedAt'] != null 
            ? DateTime.parse(result['processedAt'] as String)
            : null,
      );

      return Right(verification);
    } catch (e) {
      return Left(Failure.payment(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentStatus>> getPaymentStatus(String transactionId) async {
    try {
      final docSnapshot = await _paymentDatasource.getPaymentStatus(transactionId);

      if (!docSnapshot.exists) {
        return Left(Failure.server(message: 'Payment not found', statusCode: 404));
      }

      final status = docSnapshot.get('status') as String?;
      final paymentStatus = PaymentStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => PaymentStatus.pending,
      );

      return Right(paymentStatus);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> processRefund({
    required String transactionId,
    required double amount,
    String? reason,
  }) async {
    try {
      await _paymentDatasource.processRefund(
        transactionId: transactionId,
        amount: amount,
        reason: reason,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure.payment(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> releaseEscrowFunds({
    required String orderId,
    required String sellerId,
    required double amount,
  }) async {
    try {
      await _paymentDatasource.releaseEscrowFunds(
        orderId: orderId,
        sellerId: sellerId,
        amount: amount,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure.payment(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> getAvailablePaymentMethods() async {
    try {
      final methodsList = await _paymentDatasource.getAvailablePaymentMethods();

      final methods = methodsList
          .map((methodMap) => PaymentMethodModel.fromJson(methodMap).toEntity())
          .toList();

      return Right(methods);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderTotal>> calculateOrderTotal({
    required double subtotal,
    String? shippingMethod,
  }) async {
    try {
      final result = await _paymentDatasource.calculateOrderTotal(
        subtotal: subtotal,
        shippingMethod: shippingMethod,
      );

      final total = OrderTotalModel.fromJson(result).toEntity();
      return Right(total);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> validatePaymentDetails({
    required String email,
    required String phoneNumber,
  }) async {
    try {
      // Basic validation
      if (email.isEmpty || !email.contains('@')) {
        return Left(Failure.validation(message: 'Invalid email address'));
      }

      if (phoneNumber.isEmpty) {
        return Left(Failure.validation(message: 'Phone number is required'));
      }

      // Validate Ethiopian phone number format
      if (!phoneNumber.startsWith('+251') && !phoneNumber.startsWith('09')) {
        return Left(Failure.validation(
          message: 'Please enter a valid Ethiopian phone number',
        ));
      }

      // Call backend validation
      await _paymentDatasource.validatePaymentDetails(
        email: email,
        phoneNumber: phoneNumber,
      );

      return const Right(null);
    } catch (e) {
      return Left(Failure.validation(message: e.toString()));
    }
  }
}