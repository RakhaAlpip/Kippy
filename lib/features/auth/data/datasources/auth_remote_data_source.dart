import 'package:dio/dio.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../data/api/dio_client.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls.
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> register({
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
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data['user'] ?? response.data['data'];
      if (data == null) {
        throw const ServerException(
          message: 'Invalid response: missing user data',
        );
      }

      return {
        'user': UserModel.fromJson(data),
        'token': response.data['token'] ?? data['token'],
      };
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response?.data;
      }
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error during login: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': username,
          'username': username,
          'email': email,
          'password': password,
          'passwordRepeat': password,
          'profilePictureUrl': '',
          'phoneNumber': '',
          'bio': '',
          'website': '',
        },
      );

      final data = response.data['user'] ?? response.data['data'];
      if (data == null) {
        throw const ServerException(
          message: 'Invalid response: registration failed',
        );
      }

      return {
        'user': UserModel.fromJson(data),
        'token': response.data['token'] ?? data['token'],
      };
    } on DioException catch (e) {
      String errorMessage = 'Registration failed';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response?.data;
      }
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error during registration: $e',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.dio.get(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Logout failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
