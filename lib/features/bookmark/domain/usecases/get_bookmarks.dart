import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bookmark.dart';
import '../repositories/bookmark_repository.dart';

/// Use case: Get all saved bookmarks.
class GetBookmarks {
  final BookmarkRepository repository;
  GetBookmarks(this.repository);

  Future<Either<Failure, List<Bookmark>>> call() {
    return repository.getBookmarks();
  }
}
