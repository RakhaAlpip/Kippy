import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/social_repository.dart';

/// Use case: Delete a comment from a post.
class DeleteComment {
  final SocialRepository repository;
  DeleteComment(this.repository);

  Future<Either<Failure, void>> call({
    required String postId,
    required String commentId,
  }) {
    return repository.deleteComment(postId: postId, commentId: commentId);
  }
}
