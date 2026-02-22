import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/social_repository.dart';

/// Use case: Follow a user.
class FollowUser {
  final SocialRepository repository;
  FollowUser(this.repository);
  Future<Either<Failure, void>> call(String userId) =>
      repository.followUser(userId);
}
