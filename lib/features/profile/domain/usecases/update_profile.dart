import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

/// Use case: Update user profile.
class UpdateProfile {
  final ProfileRepository repository;
  UpdateProfile(this.repository);

  Future<Either<Failure, User>> call({
    String? fullName,
    String? bio,
    File? avatar,
  }) {
    return repository.updateProfile(
      fullName: fullName,
      bio: bio,
      avatar: avatar,
    );
  }
}
