import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post.dart';
import '../repositories/home_repository.dart';

/// Use case: Get feed posts with pagination.
class GetFeedPosts {
  final HomeRepository repository;

  GetFeedPosts(this.repository);

  Future<Either<Failure, List<Post>>> call({int page = 1}) {
    return repository.getFeedPosts(page: page);
  }
}
