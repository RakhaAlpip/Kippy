import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

/// Concrete implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final user = response['user'] as UserModel;
      final token = response['token'] as String?;

      if (token == null || token.isEmpty) {
        return const Left(
          ServerFailure(
            message: 'Login failed: No authentication token received.',
          ),
        );
      }

      await localDataSource.cacheToken(token);
      await localDataSource.cacheUser(user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.register(
        username: username,
        email: email,
        password: password,
      );

      final user = response['user'] as UserModel;
      final token = response['token'] as String?;

      if (token == null || token.isEmpty) {
        return const Left(
          ServerFailure(
            message: 'Registration failed: No authentication token received.',
          ),
        );
      }

      await localDataSource.cacheToken(token);
      await localDataSource.cacheUser(user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Registration failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearToken();
      await localDataSource.clearUser();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return localDataSource.hasToken();
  }

  @override
  Future<User?> getAuthenticatedUser() async {
    return localDataSource.getCachedUser();
  }
}
