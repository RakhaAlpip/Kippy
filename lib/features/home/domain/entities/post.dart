import 'package:equatable/equatable.dart';

/// Post entity used across the application.
class Post extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? userAvatarUrl;
  final String imageUrl;
  final String? caption;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatarUrl,
    required this.imageUrl,
    this.caption,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    userAvatarUrl,
    imageUrl,
    caption,
    likesCount,
    commentsCount,
    isLiked,
    isBookmarked,
    createdAt,
  ];
}
