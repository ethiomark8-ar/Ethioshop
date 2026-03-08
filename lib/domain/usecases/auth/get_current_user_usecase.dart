import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/entities/user_entity.dart';
import 'package:ethioshop/domain/repositories/auth_repository.dart';

/// Get Current User Use Case
/// Domain layer - Business logic for getting current user
class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<Either<Failure, UserEntity?>> call() async {
    // Call repository
    return await _authRepository.getCurrentUser();
  }

  Stream<Either<Failure, UserEntity?>> watchAuthStateChanges() {
    // Call repository stream
    return _authRepository.authStateChanges();
  }
}