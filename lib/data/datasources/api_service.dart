import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://photo-sharing-api-bootcamp.do.dibimbing.id',
    connectTimeout: const Duration(seconds: 5),
  ));

  void addToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> getPosts() async => await _dio.get('/posts');
}