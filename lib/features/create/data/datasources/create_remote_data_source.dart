import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../../../home/data/models/post_model.dart';

/// Remote data source for creating posts and stories.
abstract class CreateRemoteDataSource {
  Future<PostModel> createPost({required File image, required String caption});
  Future<void> createStory({required File image, String? caption});
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
      final fileName = image.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
        'caption': caption,
      });
      final response = await dioClient.dio.post(
        ApiEndpoints.createPost,
        data: formData,
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
  Future<void> createStory({required File image, String? caption}) async {
    try {
      final fileName = image.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
        if (caption != null) 'caption': caption,
      });
      await dioClient.dio.post(ApiEndpoints.createStory, data: formData);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to create story',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
