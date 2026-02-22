part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileFetchRequested extends ProfileEvent {
  final String userId;
  const ProfileFetchRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ProfileUpdateRequested extends ProfileEvent {
  final String? fullName;
  final String? bio;
  final File? avatar;

  const ProfileUpdateRequested({this.fullName, this.bio, this.avatar});

  @override
  List<Object?> get props => [fullName, bio, avatar];
}
