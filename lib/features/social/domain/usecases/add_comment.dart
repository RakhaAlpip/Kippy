import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';
import '../repositories/social_repository.dart';

/// Use case: Add a comment to a post.
class AddComment {
  final SocialRepository repository;
  AddComment(this.repository);

  Future<Either<Failure, Comment>> call({
    required String postId,
    required String content,
  }) {
    return repository.addComment(postId: postId, content: content);
  }
}
