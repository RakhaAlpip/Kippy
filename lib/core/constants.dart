/// App-wide constants for the Kippy application.
class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl =
      'https://photo-sharing-api-bootcamp.do.dibimbing.id'; // The endpoints already include /api/v1 so let's just use baseUrl as the base, or we can use the same baseUrl
  static const String apiKey = 'c7b411cc-0e7c-4ad1-aa3f-822b00e7734b';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'cached_user';

  // Pagination
  static const int defaultPageSize = 30;

  // Hive Boxes
  static const String bookmarkBox = 'bookmarks';
}

/// API endpoint paths.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/api/v1/login';
  static const String register = '/api/v1/register';
  static const String logout = '/api/v1/logout';

  // User
  static const String loggedUser = '/api/v1/user';
  static const String updateProfile = '/api/v1/update-profile';
  static String userProfile(String userId) => '/api/v1/user/$userId';

  // Post
  static const String createPost = '/api/v1/create-post';
  static String updatePost(String postId) => '/api/v1/update-post/$postId';
  static String deletePost(String postId) => '/api/v1/delete-post/$postId';
  static const String explorePosts = '/api/v1/explore-post';
  static String userPosts(String userId) => '/api/v1/users-post/$userId';
  static String postById(String postId) => '/api/v1/post/$postId';
  static const String followingPost =
      '/api/v1/following-post'; // This is feed posts

  // Follow
  static const String follow = '/api/v1/follow';
  static String unfollow(String userId) => '/api/v1/unfollow/$userId';
  static const String myFollowing = '/api/v1/my-following';
  static const String myFollowers = '/api/v1/my-followers';
  static String following(String userId) => '/api/v1/following/$userId';
  static String followers(String userId) => '/api/v1/followers/$userId';

  // Comment
  static const String createComment = '/api/v1/create-comment';
  static String deleteComment(String commentId) =>
      '/api/v1/delete-comment/$commentId';

  // Like
  static const String like = '/api/v1/like';
  static const String unlike = '/api/v1/unlike';

  // Story
  static const String createStory = '/api/v1/create-story';
  static String deleteStory(String storyId) => '/api/v1/delete-story/$storyId';
  static String storyById(String storyId) => '/api/v1/story/$storyId';
  static String storyViews(String storyId) => '/api/v1/story-views/$storyId';
  static const String followingStory =
      '/api/v1/following-story'; // This is feed stories

  // Upload Image
  static const String uploadImage = '/api/v1/upload-image';
}
