import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/social_repository.dart';

/// Use case: Like a post.
class LikePost {
  final SocialRepository repository;
  LikePost(this.repository);
  Future<Either<Failure, void>> call(String postId) =>
      repository.likePost(postId);
}
