import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/core/utils/constants.dart';
import 'package:ethioshop/domain/entities/user_entity.dart';
import 'package:ethioshop/domain/repositories/auth_repository.dart';

/// Register User Use Case
/// Domain layer - Business logic for user registration
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<Either<Failure, UserEntity>> call({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  }) async {
    // Validate full name
    if (fullName.isEmpty) {
      return const Left(Failure.validation(message: 'Full name is required'));
    }

    if (fullName.length < 3) {
      return const Left(Failure.validation(message: 'Full name is too short'));
    }

    // Validate email
    if (email.isEmpty) {
      return const Left(Failure.validation(message: 'Email is required'));
    }

    if (!email.contains('@') || !email.contains('.')) {
      return const Left(Failure.validation(message: 'Invalid email format'));
    }

    // Validate phone number
    if (phoneNumber.isEmpty) {
      return const Left(Failure.validation(message: 'Phone number is required'));
    }

    // Validate Ethiopian phone format
    if (!phoneNumber.startsWith('+251') && !phoneNumber.startsWith('09')) {
      return const Left(Failure.validation(
        message: 'Please enter a valid Ethiopian phone number',
      ));
    }

    // Normalize phone number
    final normalizedPhone = phoneNumber.startsWith('+251') 
        ? phoneNumber 
        : '+251${phoneNumber.substring(1)}';

    // Validate password
    if (password.isEmpty) {
      return const Left(Failure.validation(message: 'Password is required'));
    }

    if (password.length < AppConstants.minPasswordLength) {
      return Left(Failure.validation(
        message: 'Password must be at least ${AppConstants.minPasswordLength} characters',
      ));
    }

    if (password.length > AppConstants.maxPasswordLength) {
      return Left(Failure.validation(
        message: 'Password must be less than ${AppConstants.maxPasswordLength} characters',
      ));
    }

    // Validate role
    if (role != UserRole.buyer && role != UserRole.seller) {
      return const Left(Failure.validation(message: 'Invalid role selected'));
    }

    // Call repository
    return await _authRepository.registerUser(
      fullName: fullName,
      email: email,
      phoneNumber: normalizedPhone,
      password: password,
      role: role,
    );
  }
}