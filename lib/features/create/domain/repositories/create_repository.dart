import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/post.dart';

/// Abstract repository for creating posts and stories.
abstract class CreateRepository {
  Future<Either<Failure, Post>> createPost({
    required File image,
    required String caption,
  });

  Future<Either<Failure, void>> createStory({
    required File image,
    String? caption,
  });
}
