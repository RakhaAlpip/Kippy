import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/post.dart';
import '../../domain/repositories/create_repository.dart';
import '../datasources/create_remote_data_source.dart';

/// Concrete implementation of [CreateRepository].
class CreateRepositoryImpl implements CreateRepository {
  final CreateRemoteDataSource remoteDataSource;

  CreateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Post>> createPost({
    required File image,
    required String caption,
  }) async {
    try {
      final post = await remoteDataSource.createPost(
        image: image,
        caption: caption,
      );
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createStory({
    required File image,
    String? caption,
  }) async {
    try {
      await remoteDataSource.createStory(image: image, caption: caption);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
