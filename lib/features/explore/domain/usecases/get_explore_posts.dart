import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/post.dart';
import '../repositories/explore_repository.dart';

/// Use case: Get explore posts for the grid view.
class GetExplorePosts {
  final ExploreRepository repository;

  GetExplorePosts(this.repository);

  Future<Either<Failure, List<Post>>> call({int page = 1}) {
    return repository.getExplorePosts(page: page);
  }
}
