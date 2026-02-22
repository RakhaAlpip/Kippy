import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/post.dart';
import '../repositories/profile_repository.dart';

/// Use case: Get posts by a specific user.
class GetUserPosts {
  final ProfileRepository repository;
  GetUserPosts(this.repository);

  Future<Either<Failure, List<Post>>> call(String userId) {
    return repository.getUserPosts(userId);
  }
}
