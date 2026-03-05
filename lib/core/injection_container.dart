import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';
import '../data/api/dio_client.dart';
import 'utils/image_helper.dart';

// Auth
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login.dart';
import '../features/auth/domain/usecases/register.dart';
import '../features/auth/domain/usecases/logout.dart';
import '../features/auth/domain/usecases/get_authenticated_user.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Home
import '../features/home/data/datasources/home_remote_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_feed_posts.dart';
import '../features/home/domain/usecases/get_stories.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

// Explore
import '../features/explore/data/datasources/explore_remote_data_source.dart';
import '../features/explore/data/repositories/explore_repository_impl.dart';
import '../features/explore/domain/repositories/explore_repository.dart';
import '../features/explore/domain/usecases/get_explore_posts.dart';
import '../features/explore/presentation/bloc/explore_bloc.dart';

// Create
import '../features/create/data/datasources/create_remote_data_source.dart';
import '../features/create/data/repositories/create_repository_impl.dart';
import '../features/create/domain/repositories/create_repository.dart';
import '../features/create/domain/usecases/create_post.dart';
import '../features/create/domain/usecases/create_story.dart';
import '../features/create/presentation/bloc/create_bloc.dart';

// Social
import '../features/social/data/datasources/social_remote_data_source.dart';
import '../features/social/data/repositories/social_repository_impl.dart';
import '../features/social/domain/repositories/social_repository.dart';
import '../features/social/domain/usecases/like_post.dart';
import '../features/social/domain/usecases/add_comment.dart';
import '../features/social/domain/usecases/delete_comment.dart';
import '../features/social/domain/usecases/follow_user.dart';
import '../features/social/presentation/bloc/social_bloc.dart';

// Profile
import '../features/profile/data/datasources/profile_remote_data_source.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/get_user_profile.dart';
import '../features/profile/domain/usecases/get_user_posts.dart';
import '../features/profile/domain/usecases/update_profile.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';

// Bookmark
import '../features/bookmark/data/datasources/bookmark_local_data_source.dart';
import '../features/bookmark/data/repositories/bookmark_repository_impl.dart';
import '../features/bookmark/domain/repositories/bookmark_repository.dart';
import '../features/bookmark/domain/usecases/get_bookmarks.dart';
import '../features/bookmark/domain/usecases/save_bookmark.dart';
import '../features/bookmark/domain/usecases/remove_bookmark.dart';
import '../features/bookmark/presentation/bloc/bookmark_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies.
Future<void> initDependencies() async {
  //-- External --
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Hive
  await Hive.initFlutter();
  final bookmarkBox = await Hive.openBox(AppConstants.bookmarkBox);
  sl.registerLazySingleton(() => bookmarkBox);

  //-- Core --
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => ImageHelper());

  //-- Features --
  _initAuth();
  _initHome();
  _initExplore();
  _initCreate();
  _initSocial();
  _initProfile();
  _initBookmark();
}

void _initAuth() {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      register: sl(),
      logout: sl(),
      getAuthenticatedUser: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetAuthenticatedUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
}

void _initHome() {
  // Bloc
  sl.registerFactory(() => HomeBloc(getFeedPosts: sl(), getStories: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetFeedPosts(sl()));
  sl.registerLazySingleton(() => GetStories(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
}

void _initExplore() {
  // Bloc
  sl.registerFactory(() => ExploreBloc(getExplorePosts: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetExplorePosts(sl()));

  // Repository
  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ExploreRemoteDataSource>(
    () => ExploreRemoteDataSourceImpl(sl()),
  );
}

void _initCreate() {
  // Bloc
  sl.registerFactory(() => CreateBloc(createPost: sl(), createStory: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CreatePost(sl()));
  sl.registerLazySingleton(() => CreateStory(sl()));

  // Repository
  sl.registerLazySingleton<CreateRepository>(
    () => CreateRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<CreateRemoteDataSource>(
    () => CreateRemoteDataSourceImpl(sl()),
  );
}

void _initSocial() {
  // Bloc
  sl.registerFactory(
    () => SocialBloc(
      likePost: sl(),
      addComment: sl(),
      deleteComment: sl(),
      followUser: sl(),
      repository: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LikePost(sl()));
  sl.registerLazySingleton(() => AddComment(sl()));
  sl.registerLazySingleton(() => DeleteComment(sl()));
  sl.registerLazySingleton(() => FollowUser(sl()));

  // Repository
  sl.registerLazySingleton<SocialRepository>(
    () => SocialRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<SocialRemoteDataSource>(
    () => SocialRemoteDataSourceImpl(sl()),
  );
}

void _initProfile() {
  // Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getUserProfile: sl(),
      getUserPosts: sl(),
      updateProfile: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => GetUserPosts(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
}

void _initBookmark() {
  // Bloc
  sl.registerFactory(
    () => BookmarkBloc(
      getBookmarks: sl(),
      saveBookmark: sl(),
      removeBookmark: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetBookmarks(sl()));
  sl.registerLazySingleton(() => SaveBookmark(sl()));
  sl.registerLazySingleton(() => RemoveBookmark(sl()));

  // Repository
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<BookmarkLocalDataSource>(
    () => BookmarkLocalDataSourceImpl(sl()),
  );
}
