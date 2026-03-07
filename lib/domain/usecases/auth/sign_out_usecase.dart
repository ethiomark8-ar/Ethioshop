import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/repositories/auth_repository.dart';

/// Sign Out Use Case
/// Domain layer - Business logic for user sign out
class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<Either<Failure, void>> call() async {
    // Check if user is authenticated
    if (!_authRepository.isAuthenticated) {
      return const Left(Failure.auth(message: 'No user is currently signed in'));
    }

    // Call repository
    return await _authRepository.signOut();
  }
}