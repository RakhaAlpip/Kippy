import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';
import '../data/api/dio_client.dart';
import 'utils/image_helper.dart';

// Feature imports will be added as features are implemented
// import '../features/auth/...';
// import '../features/home/...';
// etc.

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
  // Auth
  _initAuth();

  // Home
  _initHome();

  // Explore
  _initExplore();

  // Create
  _initCreate();

  // Social
  _initSocial();

  // Profile
  _initProfile();

  // Bookmark
  _initBookmark();
}

void _initAuth() {
  // Bloc
  // sl.registerFactory(() => AuthBloc(login: sl(), register: sl(), logout: sl()));

  // Use Cases
  // sl.registerLazySingleton(() => Login(sl()));
  // sl.registerLazySingleton(() => Register(sl()));
  // sl.registerLazySingleton(() => Logout(sl()));

  // Repository
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
  //   remoteDataSource: sl(), localDataSource: sl()));

  // Data Sources
  // sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  // sl.registerLazySingleton(() => AuthLocalDataSource(sl()));
}

void _initHome() {
  // TODO: Register Home dependencies
}

void _initExplore() {
  // TODO: Register Explore dependencies
}

void _initCreate() {
  // TODO: Register Create dependencies
}

void _initSocial() {
  // TODO: Register Social dependencies
}

void _initProfile() {
  // TODO: Register Profile dependencies
}

void _initBookmark() {
  // TODO: Register Bookmark dependencies
}
