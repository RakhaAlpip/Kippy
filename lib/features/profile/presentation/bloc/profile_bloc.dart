import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/get_user_posts.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// BLoC for profile page.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final GetUserPosts _getUserPosts;
  final UpdateProfile _updateProfile;

  ProfileBloc({
    required GetUserProfile getUserProfile,
    required GetUserPosts getUserPosts,
    required UpdateProfile updateProfile,
  }) : _getUserProfile = getUserProfile,
       _getUserPosts = getUserPosts,
       _updateProfile = updateProfile,
       super(ProfileInitial()) {
    on<ProfileFetchRequested>(_onFetchProfile);
    on<ProfileUpdateRequested>(_onUpdateProfile);
  }

  Future<void> _onFetchProfile(
    ProfileFetchRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final userResult = await _getUserProfile(event.userId);
    final postsResult = await _getUserPosts(event.userId);

    userResult.fold((failure) => emit(ProfileError(failure.message)), (user) {
      postsResult.fold(
        (failure) => emit(ProfileError(failure.message)),
        (posts) => emit(ProfileLoaded(user: user, posts: posts)),
      );
    });
  }

  Future<void> _onUpdateProfile(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _updateProfile(
      fullName: event.fullName,
      bio: event.bio,
      avatar: event.avatar,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileUpdateSuccess(user)),
    );
  }
}
