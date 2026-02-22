import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bookmark.dart';
import '../repositories/bookmark_repository.dart';

/// Use case: Save a post as bookmark.
class SaveBookmark {
  final BookmarkRepository repository;
  SaveBookmark(this.repository);

  Future<Either<Failure, void>> call(Bookmark bookmark) {
    return repository.saveBookmark(bookmark);
  }
}
