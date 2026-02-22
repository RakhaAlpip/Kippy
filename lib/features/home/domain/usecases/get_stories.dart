import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/story.dart';
import '../repositories/home_repository.dart';

/// Use case: Get stories from followed users.
class GetStories {
  final HomeRepository repository;

  GetStories(this.repository);

  Future<Either<Failure, List<Story>>> call() {
    return repository.getStories();
  }
}
