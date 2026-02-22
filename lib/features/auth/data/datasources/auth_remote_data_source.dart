import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      // TODO: Extract token from response and return it along with user
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.register,
        data: {'username': username, 'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Registration failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Logout failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
