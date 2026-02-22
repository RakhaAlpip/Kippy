import 'package:equatable/equatable.dart';

/// Base class for all failures in the app.
abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message = 'An unexpected error occurred'});

  @override
  List<Object?> get props => [message];
}

/// Failure originating from the server/API.
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred'});
}

/// Failure originating from local cache/storage.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

/// Failure due to no internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}
