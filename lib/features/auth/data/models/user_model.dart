import '../../domain/entities/user.dart';

/// Data model for User with JSON serialization.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.fullName,
    super.bio,
    super.avatarUrl,
    super.followersCount,
    super.followingCount,
    super.postsCount,
    super.isFollowed,
  });

  /// Create a UserModel from JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      postsCount: json['posts_count'] ?? 0,
      isFollowed: json['is_followed'] ?? false,
    );
  }

  /// Convert UserModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'bio': bio,
      'avatar_url': avatarUrl,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
      'is_followed': isFollowed,
    };
  }
}
