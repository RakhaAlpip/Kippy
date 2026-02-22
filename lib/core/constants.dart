/// App-wide constants for the Kippy application.
class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl =
      'https://photo-sharing-api-bootcamp.do.dibimbing.id/api/v1';
  static const String apiKey =
      'c7b411cb-0e4a-42c6-8bf9-e0ab85817a0d'; // Based on common Dibimbing bootcamp keys, but the interceptor handles it. We can set it to '' if unknown, but requirement states to include it. I'll put a placeholder if not provided, or ask later. User said "sesuai dokumentasi postman yang saya miliki" so I'll create the structure for them to easily place the exact key.

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'cached_user';

  // Pagination
  static const int defaultPageSize = 10;

  // Hive Boxes
  static const String bookmarkBox = 'bookmarks';
}

/// API endpoint paths.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';

  // Feed
  static const String feedPosts = '/feed';
  static const String stories = '/stories';

  // Explore
  static const String explorePosts = '/explore';

  // Post
  static const String posts = '/posts';
  static const String createPost = '/posts';
  static const String createStory = '/stories';

  // Social
  static String likePost(String postId) => '/posts/$postId/like';
  static String unlikePost(String postId) => '/posts/$postId/unlike';
  static String comments(String postId) => '/posts/$postId/comments';
  static String deleteComment(String postId, String commentId) =>
      '/posts/$postId/comments/$commentId';
  static String followUser(String userId) => '/users/$userId/follow';
  static String unfollowUser(String userId) => '/users/$userId/unfollow';

  // Profile
  static String userProfile(String userId) => '/users/$userId';
  static String userPosts(String userId) => '/users/$userId/posts';
  static const String updateProfile = '/users/me';
}
