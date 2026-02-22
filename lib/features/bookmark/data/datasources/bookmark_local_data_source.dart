import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/bookmark_model.dart';

/// Local data source for bookmarks using Hive.
abstract class BookmarkLocalDataSource {
  Future<void> saveBookmark(BookmarkModel bookmark);
  Future<void> removeBookmark(String postId);
  List<BookmarkModel> getBookmarks();
  bool isBookmarked(String postId);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  final Box box;

  BookmarkLocalDataSourceImpl(this.box);

  @override
  Future<void> saveBookmark(BookmarkModel bookmark) async {
    try {
      await box.put(bookmark.postId, bookmark.toMap());
    } catch (e) {
      throw const CacheException(message: 'Failed to save bookmark');
    }
  }

  @override
  Future<void> removeBookmark(String postId) async {
    try {
      await box.delete(postId);
    } catch (e) {
      throw const CacheException(message: 'Failed to remove bookmark');
    }
  }

  @override
  List<BookmarkModel> getBookmarks() {
    try {
      return box.values
          .map((value) => BookmarkModel.fromMap(value as Map<dynamic, dynamic>))
          .toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to get bookmarks');
    }
  }

  @override
  bool isBookmarked(String postId) {
    return box.containsKey(postId);
  }
}
