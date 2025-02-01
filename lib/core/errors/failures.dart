import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    required String message,
    String? code,
    this.errors,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [...super.props, errors];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Unauthorized access',
    String? code,
  }) : super(message: message, code: code);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    String message = 'An unexpected error occurred',
    String? code,
  }) : super(message: message, code: code);
} 