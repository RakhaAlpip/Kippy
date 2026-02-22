import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post.dart';
import '../entities/story.dart';

/// Abstract repository for the home feed.
abstract class HomeRepository {
  /// Fetch paginated feed posts from followed users.
  Future<Either<Failure, List<Post>>> getFeedPosts({int page = 1});

  /// Fetch stories from followed users.
  Future<Either<Failure, List<Story>>> getStories();
}
