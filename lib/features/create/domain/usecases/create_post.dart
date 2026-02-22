import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/post.dart';
import '../repositories/create_repository.dart';

/// Use case: Create a new post.
class CreatePost {
  final CreateRepository repository;

  CreatePost(this.repository);

  Future<Either<Failure, Post>> call({
    required File image,
    required String caption,
  }) {
    return repository.createPost(image: image, caption: caption);
  }
}
