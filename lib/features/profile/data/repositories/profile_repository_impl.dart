import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

/// Concrete implementation of [ProfileRepository].
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      final user = await remoteDataSource.getUserProfile(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? bio,
    File? avatar,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        fullName: fullName,
        bio: bio,
        avatar: avatar,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getUserPosts(String userId) async {
    try {
      final posts = await remoteDataSource.getUserPosts(userId);
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
