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
      final Map<String, dynamic> formDataMap = {};
      if (fullName != null) formDataMap['full_name'] = fullName;
      if (bio != null) formDataMap['bio'] = bio;
      if (avatar != null) {
        final fileName = avatar.path.split('/').last;
        formDataMap['avatar'] = await MultipartFile.fromFile(
          avatar.path,
          filename: fileName,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await dioClient.dio.put(
        ApiEndpoints.updateProfile,
        data: formData,
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
      final response = await dioClient.dio.get(ApiEndpoints.userPosts(userId));
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => PostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch user posts',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
