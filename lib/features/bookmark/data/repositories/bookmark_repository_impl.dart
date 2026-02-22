import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_data_source.dart';
import '../models/bookmark_model.dart';

/// Concrete implementation of [BookmarkRepository].
class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveBookmark(Bookmark bookmark) async {
    try {
      final model = BookmarkModel.fromEntity(bookmark);
      await localDataSource.saveBookmark(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String postId) async {
    try {
      await localDataSource.removeBookmark(postId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarks() async {
    try {
      final bookmarks = localDataSource.getBookmarks();
      return Right(bookmarks);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<bool> isBookmarked(String postId) async {
    return localDataSource.isBookmarked(postId);
  }
}
