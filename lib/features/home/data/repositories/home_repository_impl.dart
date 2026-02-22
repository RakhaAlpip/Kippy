import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

/// Concrete implementation of [HomeRepository].
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Post>>> getFeedPosts({int page = 1}) async {
    try {
      final posts = await remoteDataSource.getFeedPosts(page: page);
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    try {
      final stories = await remoteDataSource.getStories();
      return Right(stories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
