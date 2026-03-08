import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/user_firestore_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource authDatasource;
  final UserFirestoreDatasource userDatasource;

  AuthRepositoryImpl({
    required this.authDatasource,
    required this.userDatasource,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await authDatasource.login(
        email: email,
        password: password,
      );

      final user = await userDatasource.getUserById(userCredential.user!.uid);
      if (user == null) {
        return const Left(NotFoundFailure(message: 'User not found'));
      }

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final userCredential = await authDatasource.register(
        email: email,
        password: password,
      );

      final user = UserEntity(
        id: userCredential.user!.uid,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );

      await userDatasource.createUser(user);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authDatasource.logout();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await authDatasource.forgotPassword(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await authDatasource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    try {
      await authDatasource.verifyEmail(token);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    try {
      final user = authDatasource.currentUser;
      if (user == null) {
        return const Left(AuthFailure());
      }
      await user.sendEmailVerification();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = authDatasource.currentUser;
      if (firebaseUser == null) {
        return const Right(null);
      }

      final user = await userDatasource.getUserById(firebaseUser.uid);
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailVerified() async {
    try {
      final user = authDatasource.currentUser;
      if (user == null) {
        return const Left(AuthFailure());
      }
      await user.reload();
      return Right(user.emailVerified);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = authDatasource.currentUser;
      if (user == null) {
        return const Left(AuthFailure());
      }

      await authDatasource.updatePassword(
        user: user,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? location,
  }) async {
    try {
      final user = authDatasource.currentUser;
      if (user == null) {
        return const Left(AuthFailure());
      }

      final updatedUser = await userDatasource.updateUser(
        userId: user.uid,
        fullName: fullName,
        phoneNumber: phoneNumber,
        location: location,
      );

      return Right(updatedUser);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    try {
      final user = authDatasource.currentUser;
      if (user == null) {
        return const Left(AuthFailure());
      }

      final imageUrl = await userDatasource.uploadProfileImage(
        userId: user.uid,
        imagePath: imagePath,
      );

      return Right(imageUrl);
    } catch (e) {
      return Left(FileUploadFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final user = authDatasource.currentUser;
      if (user == null) {
        return const Left(AuthFailure());
      }

      await userDatasource.deleteUser(user.uid);
      await user.delete();

      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return authDatasource.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await userDatasource.getUserById(firebaseUser.uid);
    });
  }

  Failure _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthFailure(message: 'No user found with this email');
      case 'wrong-password':
        return const AuthFailure(message: 'Incorrect password');
      case 'email-already-in-use':
        return const AuthFailure(message: 'Email already registered');
      case 'invalid-email':
        return const ValidationFailure(message: 'Invalid email address');
      case 'weak-password':
        return const ValidationFailure(message: 'Password is too weak');
      case 'too-many-requests':
        return const AuthFailure(message: 'Too many attempts. Try again later');
      default:
        return AuthFailure(message: e.message ?? 'Authentication failed');
    }
  }
}