import 'package:equatable/equatable.dart';

/// Comment entity.
class Comment extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String? userAvatarUrl;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    this.userAvatarUrl,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, postId, userId, username, content, createdAt];
}
