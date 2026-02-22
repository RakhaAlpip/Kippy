import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for authentication operations.
abstract class AuthRepository {
  /// Login with email and password. Returns a User on success.
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register a new user account.
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
  });

  /// Logout the current user.
  Future<Either<Failure, void>> logout();

  /// Check if user is currently authenticated (has valid token).
  Future<bool> isAuthenticated();
}
