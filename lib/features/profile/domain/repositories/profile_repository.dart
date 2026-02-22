import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';

/// Abstract repository for profile operations.
abstract class ProfileRepository {
  Future<Either<Failure, User>> getUserProfile(String userId);
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? bio,
    File? avatar,
  });
  Future<Either<Failure, List<Post>>> getUserPosts(String userId);
}
