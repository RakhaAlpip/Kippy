import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';

/// Local data source for caching authentication data (JWT token).
abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  bool hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(AppConstants.tokenKey, token);
    } catch (e) {
      throw const CacheException(message: 'Failed to cache token');
    }
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(AppConstants.tokenKey);
  }

  @override
  Future<void> clearToken() async {
    try {
      await sharedPreferences.remove(AppConstants.tokenKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear token');
    }
  }

  @override
  bool hasToken() {
    final token = sharedPreferences.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}
