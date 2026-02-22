import 'package:equatable/equatable.dart';

/// Bookmark entity for locally saved posts.
class Bookmark extends Equatable {
  final String postId;
  final String imageUrl;
  final String? caption;
  final String username;
  final DateTime savedAt;

  const Bookmark({
    required this.postId,
    required this.imageUrl,
    this.caption,
    required this.username,
    required this.savedAt,
  });

  @override
  List<Object?> get props => [postId, imageUrl, caption, username, savedAt];
}
