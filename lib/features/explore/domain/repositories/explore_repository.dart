import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/post.dart';

/// Abstract repository for explore functionality.
abstract class ExploreRepository {
  /// Fetch explore posts (random posts from all users).
  Future<Either<Failure, List<Post>>> getExplorePosts({int page = 1});
}
