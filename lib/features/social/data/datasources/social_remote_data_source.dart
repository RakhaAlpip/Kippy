import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../models/comment_model.dart';

/// Remote data source for social interactions.
abstract class SocialRemoteDataSource {
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
  Future<List<CommentModel>> getComments(String postId);
  Future<CommentModel> addComment({
    required String postId,
    required String content,
  });
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  });
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  final DioClient dioClient;

  SocialRemoteDataSourceImpl(this.dioClient);

  @override
  Future<void> likePost(String postId) async {
    try {
      await dioClient.dio.post(ApiEndpoints.likePost(postId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to like post',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> unlikePost(String postId) async {
    try {
      await dioClient.dio.post(ApiEndpoints.unlikePost(postId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to unlike post',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.comments(postId));
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => CommentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch comments',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<CommentModel> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.comments(postId),
        data: {'content': content},
      );
      return CommentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to add comment',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await dioClient.dio.delete(ApiEndpoints.deleteComment(postId, commentId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to delete comment',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> followUser(String userId) async {
    try {
      await dioClient.dio.post(ApiEndpoints.followUser(userId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to follow user',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    try {
      await dioClient.dio.post(ApiEndpoints.unfollowUser(userId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to unfollow user',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
