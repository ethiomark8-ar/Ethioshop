import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Server error occurred. Please try again.',
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'No internet connection. Please check your network.',
  }) : super(message: message);
}

class AuthFailure extends Failure {
  const AuthFailure({
    String message = 'Authentication failed. Please login again.',
  }) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    String message = 'Invalid input data.',
  }) : super(message: message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Resource not found.',
  }) : super(message: message);
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    String message = 'Permission denied.',
  }) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache error occurred.',
  }) : super(message: message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    String message = 'Database error occurred.',
  }) : super(message: message);
}

class PaymentFailure extends Failure {
  const PaymentFailure({
    String message = 'Payment failed. Please try again.',
  }) : super(message: message);
}

class FileUploadFailure extends Failure {
  const FileUploadFailure({
    String message = 'File upload failed.',
  }) : super(message: message);
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'An unknown error occurred.',
  }) : super(message: message);
}