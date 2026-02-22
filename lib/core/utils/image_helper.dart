import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

/// Utility class for image picking and upload preparation.
class ImageHelper {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery.
  Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    return image != null ? File(image.path) : null;
  }

  /// Pick an image from the camera.
  Future<File?> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    return image != null ? File(image.path) : null;
  }

  /// Convert a File to a MultipartFile for Dio upload.
  Future<MultipartFile> toMultipartFile(File file) async {
    final fileName = file.path.split('/').last;
    return MultipartFile.fromFile(file.path, filename: fileName);
  }
}
