import '../../domain/entities/bookmark.dart';

/// Data model for Bookmark with Hive serialization.
class BookmarkModel extends Bookmark {
  const BookmarkModel({
    required super.postId,
    required super.imageUrl,
    super.caption,
    required super.username,
    required super.savedAt,
  });

  /// Create from a Hive map.
  factory BookmarkModel.fromMap(Map<dynamic, dynamic> map) {
    return BookmarkModel(
      postId: map['postId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      caption: map['caption'],
      username: map['username'] ?? '',
      savedAt: DateTime.tryParse(map['savedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to a Hive-compatible map.
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'imageUrl': imageUrl,
      'caption': caption,
      'username': username,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  /// Create from a Bookmark entity.
  factory BookmarkModel.fromEntity(Bookmark bookmark) {
    return BookmarkModel(
      postId: bookmark.postId,
      imageUrl: bookmark.imageUrl,
      caption: bookmark.caption,
      username: bookmark.username,
      savedAt: bookmark.savedAt,
    );
  }
}
