import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure(String? msg)
    : message =
          msg != null && msg.isNotEmpty ? msg : 'An unknown error occurred';

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure([String? message]) : super(message ?? 'Server error occurred');
}

class NetworkFailure extends Failure {
  NetworkFailure([String? message])
    : super(message ?? 'Network connection error');
}

class CacheFailure extends Failure {
  CacheFailure([String? message]) : super(message ?? 'Cache error occurred');
}
