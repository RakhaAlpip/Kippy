import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/post.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_data_source.dart';

/// Concrete implementation of [ExploreRepository].
class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  ExploreRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Post>>> getExplorePosts({int page = 1}) async {
    try {
      final posts = await remoteDataSource.getExplorePosts(page: page);
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
