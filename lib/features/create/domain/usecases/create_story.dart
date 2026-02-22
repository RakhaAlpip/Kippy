import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/create_repository.dart';

/// Use case: Create a new story.
class CreateStory {
  final CreateRepository repository;

  CreateStory(this.repository);

  Future<Either<Failure, void>> call({required File image, String? caption}) {
    return repository.createStory(image: image, caption: caption);
  }
}
