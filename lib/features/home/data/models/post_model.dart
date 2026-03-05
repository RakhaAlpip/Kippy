import '../../domain/entities/post.dart';

/// Data model for Post with JSON serialization.
class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.username,
    super.userAvatarUrl,
    required super.imageUrl,
    super.caption,
    super.likesCount,
    super.commentsCount,
    super.isLiked,
    super.isBookmarked,
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id']?.toString() ?? '',
      userId: (json['userId'] ?? json['user_id'])?.toString() ?? '',
      username: json['username'] ?? json['user']?['username'] ?? '',
      userAvatarUrl:
          json['userAvatarUrl'] ??
          json['user_avatar_url'] ??
          json['user']?['profilePictureUrl'],
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      caption: json['caption'],
      likesCount: json['totalLikes'] ?? json['likes_count'] ?? 0,
      commentsCount: json['totalComments'] ?? json['comments_count'] ?? 0,
      isLiked: json['isLike'] ?? json['is_liked'] ?? false,
      isBookmarked: false,
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'user_avatar_url': userAvatarUrl,
      'image_url': imageUrl,
      'caption': caption,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
