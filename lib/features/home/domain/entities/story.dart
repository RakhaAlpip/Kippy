import 'package:equatable/equatable.dart';

/// Story entity.
class Story extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? userAvatarUrl;
  final String imageUrl;
  final DateTime createdAt;
  final bool isSeen;

  const Story({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatarUrl,
    required this.imageUrl,
    required this.createdAt,
    this.isSeen = false,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    imageUrl,
    createdAt,
    isSeen,
  ];
}
