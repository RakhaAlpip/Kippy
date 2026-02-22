import 'package:equatable/equatable.dart';

/// Core User entity used across the application.
class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? bio;
  final String? avatarUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowed;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.bio,
    this.avatarUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isFollowed = false,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullName,
    bio,
    avatarUrl,
    followersCount,
    followingCount,
    postsCount,
    isFollowed,
  ];
}
