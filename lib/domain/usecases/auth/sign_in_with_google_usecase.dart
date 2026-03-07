import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/entities/user_entity.dart';
import 'package:ethioshop/domain/repositories/auth_repository.dart';

/// Sign In With Google Use Case
/// Domain layer - Business logic for Google authentication
class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  Future<Either<Failure, UserEntity>> call() async {
    // Call repository
    return await _authRepository.signInWithGoogle();
  }
}