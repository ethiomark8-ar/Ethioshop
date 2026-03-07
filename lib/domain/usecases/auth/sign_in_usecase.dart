import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/entities/user_entity.dart';
import 'package:ethioshop/domain/repositories/auth_repository.dart';

/// Sign In Use Case
/// Domain layer - Business logic for user sign in
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Validate input
    if (email.isEmpty) {
      return const Left(Failure.validation(message: 'Email is required'));
    }

    if (password.isEmpty) {
      return const Left(Failure.validation(message: 'Password is required'));
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      return const Left(Failure.validation(message: 'Invalid email format'));
    }

    // Call repository
    return await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}