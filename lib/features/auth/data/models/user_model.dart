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
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: (json['name'] ?? json['full_name'])?.toString(),
      bio: json['bio']?.toString(),
      avatarUrl: (json['profilePictureUrl'] ?? json['avatar_url'])?.toString(),
      followersCount:
          int.tryParse(
            (json['totalFollowers'] ?? json['followers_count'] ?? 0).toString(),
          ) ??
          0,
      followingCount:
          int.tryParse(
            (json['totalFollowing'] ?? json['following_count'] ?? 0).toString(),
          ) ??
          0,
      postsCount:
          int.tryParse(
            (json['totalPosts'] ?? json['posts_count'] ?? 0).toString(),
          ) ??
          0,
      isFollowed: json['is_followed'] == true,
    );
  }

  /// Convert UserModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': fullName,
      'bio': bio,
      'profilePictureUrl': avatarUrl,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
      'is_followed': isFollowed,
    };
  }
}
