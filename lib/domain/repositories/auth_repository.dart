import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../failures/failure.dart';

abstract class AuthRepository {
  // Authentication
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> verifyEmail(String token);

  Future<Either<Failure, void>> resendVerificationEmail();

  // User Session
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, bool>> isEmailVerified();

  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  // Profile
  Future<Either<Failure, UserEntity>> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? location,
  });

  Future<Either<Failure, String>> uploadProfileImage(String imagePath);

  Future<Either<Failure, void>> deleteAccount();

  // Streams
  Stream<UserEntity?> get authStateChanges;
}