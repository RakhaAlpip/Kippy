import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';

/// Remote data source for the home feed.
abstract class HomeRemoteDataSource {
  Future<List<PostModel>> getFeedPosts({int page = 1});
  Future<List<StoryModel>> getStories();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<PostModel>> getFeedPosts({int page = 1}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.followingPost,
        queryParameters: {'page': page, 'size': AppConstants.defaultPageSize},
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
        message: e.response?.data?['message'] ?? 'Failed to fetch feed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<StoryModel>> getStories() async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.followingStory,
        queryParameters: {'page': 1, 'size': AppConstants.defaultPageSize},
      );
      final dynamic rawData = response.data['data'];
      final List<dynamic> data = rawData is List
          ? rawData
          : (rawData is Map
                ? (rawData['stories'] ?? rawData['data'] ?? [])
                : []);
      return data.map((json) => StoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch stories',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
