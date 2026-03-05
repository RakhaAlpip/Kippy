import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../../../home/data/models/post_model.dart';

/// Remote data source for creating posts and stories.
abstract class CreateRemoteDataSource {
  Future<PostModel> createPost({required File image, required String caption});
  Future<PostModel> updatePost({
    required String postId,
    File? image,
    required String caption,
  });
  Future<void> deletePost(String postId);
  Future<void> createStory({required File image, String? caption});
  Future<void> deleteStory(String storyId);
}

class CreateRemoteDataSourceImpl implements CreateRemoteDataSource {
  final DioClient dioClient;

  CreateRemoteDataSourceImpl(this.dioClient);

  @override
  Future<PostModel> createPost({
    required File image,
    required String caption,
  }) async {
    try {
      // 1. Upload image
      final fileName = image.path.split('/').last;
      final uploadFormData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
      });
      final uploadRes = await dioClient.dio.post(
        ApiEndpoints.uploadImage,
        data: uploadFormData,
      );
      final url =
          uploadRes.data['data']['url'] ?? uploadRes.data['data']['imageUrl'];

      // 2. Create post
      final response = await dioClient.dio.post(
        ApiEndpoints.createPost,
        data: {'imageUrl': url, 'caption': caption},
      );
      return PostModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to create post',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PostModel> updatePost({
    required String postId,
    File? image,
    required String caption,
  }) async {
    try {
      String? url;
      if (image != null) {
        final fileName = image.path.split('/').last;
        final uploadFormData = FormData.fromMap({
          'image': await MultipartFile.fromFile(image.path, filename: fileName),
        });
        final uploadRes = await dioClient.dio.post(
          ApiEndpoints.uploadImage,
          data: uploadFormData,
        );
        url =
            uploadRes.data['data']['url'] ?? uploadRes.data['data']['imageUrl'];
      }

      final response = await dioClient.dio.post(
        ApiEndpoints.updatePost(postId),
        data: {if (url != null) 'imageUrl': url, 'caption': caption},
      );
      return PostModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to update post',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await dioClient.dio.delete(ApiEndpoints.deletePost(postId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to delete post',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> createStory({required File image, String? caption}) async {
    try {
      // 1. Upload image
      final fileName = image.path.split('/').last;
      final uploadFormData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
      });
      final uploadRes = await dioClient.dio.post(
        ApiEndpoints.uploadImage,
        data: uploadFormData,
      );
      final url =
          uploadRes.data['data']['url'] ?? uploadRes.data['data']['imageUrl'];

      // 2. Create story
      await dioClient.dio.post(
        ApiEndpoints.createStory,
        data: {
          'imageUrl': url,
          if (caption != null && caption.isNotEmpty) 'caption': caption,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to create story',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteStory(String storyId) async {
    try {
      await dioClient.dio.delete(ApiEndpoints.deleteStory(storyId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to delete story',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
