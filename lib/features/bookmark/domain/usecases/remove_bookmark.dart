import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/bookmark_repository.dart';

/// Use case: Remove a bookmark.
class RemoveBookmark {
  final BookmarkRepository repository;
  RemoveBookmark(this.repository);

  Future<Either<Failure, void>> call(String postId) {
    return repository.removeBookmark(postId);
  }
}
