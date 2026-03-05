import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Local data source for caching authentication data (JWT token and User profile).
abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  bool hasToken();

  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
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

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await sharedPreferences.setString(AppConstants.userKey, userJson);
    } catch (e) {
      throw const CacheException(message: 'Failed to cache user');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(AppConstants.userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(AppConstants.userKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear user');
    }
  }
}
