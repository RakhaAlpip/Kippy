import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/get_started_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/main_wrapper_page.dart';
import '../features/explore/presentation/pages/explore_page.dart';
import '../features/create/presentation/pages/create_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/bookmark/presentation/pages/bookmark_page.dart';

/// Named routes for the Kippy app.
class AppRoutes {
  static const String splash = '/';
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String create = '/create';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String bookmarks = '/bookmarks';
}

/// Router that maps route names to page widgets.
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.getStarted:
        return MaterialPageRoute(builder: (_) => const GetStartedPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const MainWrapperPage(),
        ); // Changed HomePage to MainWrapperPage
      case AppRoutes.explore:
        return MaterialPageRoute(builder: (_) => const ExplorePage());
      case AppRoutes.create:
        return MaterialPageRoute(builder: (_) => const CreatePage());
      case AppRoutes.profile:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ProfilePage(userId: userId));
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case AppRoutes.bookmarks:
        return MaterialPageRoute(builder: (_) => const BookmarkPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
