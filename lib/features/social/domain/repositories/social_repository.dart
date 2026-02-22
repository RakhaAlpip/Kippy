import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';

/// Abstract repository for social interactions.
abstract class SocialRepository {
  Future<Either<Failure, void>> likePost(String postId);
  Future<Either<Failure, void>> unlikePost(String postId);
  Future<Either<Failure, List<Comment>>> getComments(String postId);
  Future<Either<Failure, Comment>> addComment({
    required String postId,
    required String content,
  });
  Future<Either<Failure, void>> deleteComment({
    required String postId,
    required String commentId,
  });
  Future<Either<Failure, void>> followUser(String userId);
  Future<Either<Failure, void>> unfollowUser(String userId);
}
