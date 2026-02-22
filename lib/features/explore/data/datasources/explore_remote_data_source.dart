import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../../../home/data/models/post_model.dart';

/// Remote data source for explore posts.
abstract class ExploreRemoteDataSource {
  Future<List<PostModel>> getExplorePosts({int page = 1});
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final DioClient dioClient;

  ExploreRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<PostModel>> getExplorePosts({int page = 1}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.explorePosts,
        queryParameters: {'page': page, 'limit': AppConstants.defaultPageSize},
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => PostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] ?? 'Failed to fetch explore posts',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
