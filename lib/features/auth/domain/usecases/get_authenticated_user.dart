import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case to retrieve the currently authenticated user from local storage.
class GetAuthenticatedUser {
  final AuthRepository repository;

  GetAuthenticatedUser(this.repository);

  Future<User?> call() async {
    return repository.getAuthenticatedUser();
  }
}
