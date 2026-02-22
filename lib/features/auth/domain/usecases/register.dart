import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case: Register a new user account.
class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, User>> call({
    required String username,
    required String email,
    required String password,
  }) {
    return repository.register(
      username: username,
      email: email,
      password: password,
    );
  }
}
