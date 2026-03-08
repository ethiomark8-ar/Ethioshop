import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/entities/user_entity.dart';
import 'package:ethioshop/domain/repositories/payment_repository.dart';

/// Create Payment Intent Use Case
/// Domain layer - Business logic for creating Chapa payment intent
class CreatePaymentIntentUseCase {
  final PaymentRepository _paymentRepository;

  CreatePaymentIntentUseCase(this._paymentRepository);

  Future<Either<Failure, PaymentIntent>> call({
    required double amount,
    required String orderId,
    required UserEntity user,
    String? callbackUrl,
  }) async {
    // Validate amount
    if (amount <= 0) {
      return const Left(Failure.validation(message: 'Invalid payment amount'));
    }

    // Validate order ID
    if (orderId.isEmpty) {
      return const Left(Failure.validation(message: 'Order ID is required'));
    }

    // Parse full name
    final nameParts = user.fullName.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    // Call repository
    return await _paymentRepository.createPaymentIntent(
      amount: amount,
      orderId: orderId,
      email: user.email,
      phoneNumber: user.phoneNumber,
      firstName: firstName,
      lastName: lastName,
      callbackUrl: callbackUrl,
    );
  }
}