import '../../domain/entities/story.dart';

/// Data model for Story with JSON serialization.
class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.userId,
    required super.username,
    super.userAvatarUrl,
    required super.imageUrl,
    required super.createdAt,
    super.isSeen,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      username: json['username'] ?? '',
      userAvatarUrl: json['user_avatar_url'],
      imageUrl: json['image_url'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isSeen: json['is_seen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'user_avatar_url': userAvatarUrl,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'is_seen': isSeen,
    };
  }
}
