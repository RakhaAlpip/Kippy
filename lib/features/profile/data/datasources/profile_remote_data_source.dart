import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../home/data/models/post_model.dart';

/// Remote data source for profile operations.
abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile(String userId);
  Future<UserModel> updateProfile({
    String? fullName,
    String? bio,
    File? avatar,
  });
  Future<List<PostModel>> getUserPosts(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.userProfile(userId),
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch profile',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? bio,
    File? avatar,
  }) async {
    try {
      String? avatarUrl;
      // 1. Upload new avatar if provided
      if (avatar != null) {
        final fileName = avatar.path.split('/').last;
        final uploadFormData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            avatar.path,
            filename: fileName,
          ),
        });
        final uploadRes = await dioClient.dio.post(
          ApiEndpoints.uploadImage,
          data: uploadFormData,
        );
        avatarUrl =
            uploadRes.data['data']['url'] ?? uploadRes.data['data']['imageUrl'];
      }

      // 2. Update profile
      final Map<String, dynamic> data = {};
      if (fullName != null) data['name'] = fullName;
      if (bio != null) data['bio'] = bio;
      if (avatarUrl != null) data['profilePictureUrl'] = avatarUrl;

      final response = await dioClient.dio.post(
        ApiEndpoints.updateProfile,
        data: data,
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to update profile',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.userPosts(userId),
        queryParameters: {'page': 1, 'size': AppConstants.defaultPageSize},
      );
      final dynamic rawData = response.data['data'];
      final List<dynamic> data = rawData is List
          ? rawData
          : (rawData is Map ? (rawData['posts'] ?? rawData['data'] ?? []) : []);
      return data
          .map((json) => PostModel.fromJson(json))
          .where((post) => post.imageUrl.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch user posts',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
