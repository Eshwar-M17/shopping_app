/// Failure classes for error handling in the domain layer.
///
/// This file defines base and specific failure types used throughout the application
/// to handle errors in a type-safe way. The failure classes are part of the
/// Either pattern (from dartz package) used to represent success or failure results.
import 'package:equatable/equatable.dart';

/// Abstract base failure class that all specific failure types extend.
///
/// This class provides common behavior for all failures, including a message property
/// and equality comparison based on that message. It uses Equatable for value-based
/// equality checking.
abstract class Failure extends Equatable {
  /// A user-friendly error message describing what went wrong
  final String message;

  /// Creates a failure with the given message, or a default message if none provided.
  ///
  /// This constructor ensures that all failures have a meaningful error message.
  Failure(String? msg)
    : message =
          msg != null && msg.isNotEmpty ? msg : 'An unknown error occurred';

  @override
  List<Object> get props => [message];
}

/// Represents failures that occur on the server side during API calls.
///
/// This is used when the server returns an error response (e.g., HTTP 4xx or 5xx status codes)
/// or when there's an exception during server communication.
class ServerFailure extends Failure {
  /// Creates a server failure with an optional custom message.
  ServerFailure([String? message]) : super(message ?? 'Server error occurred');
}

/// Represents failures related to network connectivity.
///
/// This is used when the device can't connect to the network, such as in
/// cases of no internet connection or timeouts.
class NetworkFailure extends Failure {
  /// Creates a network failure with an optional custom message.
  NetworkFailure([String? message])
    : super(message ?? 'Network connection error');
}

/// Represents failures related to local caching operations.
///
/// This is used when there's an error reading from or writing to local storage.
class CacheFailure extends Failure {
  /// Creates a cache failure with an optional custom message.
  CacheFailure([String? message]) : super(message ?? 'Cache error occurred');
}
