import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bookmark.dart';

/// Abstract repository for bookmark operations (local only).
abstract class BookmarkRepository {
  Future<Either<Failure, void>> saveBookmark(Bookmark bookmark);
  Future<Either<Failure, void>> removeBookmark(String postId);
  Future<Either<Failure, List<Bookmark>>> getBookmarks();
  Future<bool> isBookmarked(String postId);
}
