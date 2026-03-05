import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

/// Configured Dio HTTP client with interceptors for auth and logging.
class DioClient {
  late final Dio _dio;
  final SharedPreferences _sharedPreferences;

  DioClient(this._sharedPreferences) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Automatically injecting the API key from Constants
          'apiKey': AppConstants.apiKey,
        },
      ),
    );

    _dio.interceptors.addAll([
      _authInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  Dio get dio => _dio;

  /// Interceptor that injects the JWT token into every request defensively.
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _sharedPreferences.getString(AppConstants.tokenKey);

        // If token exists, attach it as Bearer Authorization
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Proceed with the request
        handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle common unauthorized errors (401)
        if (e.response?.statusCode == 401) {
          // In a full implementation, you might trigger a global logout here
          // e.g. using a StreamController or callback.
          // Token expired handling
        }
        handler.next(e);
      },
    );
  }
}
