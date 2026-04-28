import 'dart:convert';
import 'dart:io';

import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class PhotoRepository {
  PhotoRepository();

  factory PhotoRepository.instance() => _instance ??= PhotoRepository();

  static PhotoRepository? _instance;

  static const _jsonFileName = 'photos.json';
  static const _imagesDirName = 'gallery_images';

  String? _cachedPath;

  Future<String> get _storagePath async {
    if (_cachedPath != null) return _cachedPath!;
    final appDir = await getApplicationDocumentsDirectory();
    _cachedPath = appDir.path;
    return _cachedPath!;
  }

  Future<String> getBaseImagePath() async =>
      _storagePath.then((path) => '$path/$_imagesDirName');

  Future<List<Photo>> getPhotos() async {
    try {
      final path = await _storagePath;
      final file = File('$path/$_jsonFileName');
      if (!file.existsSync()) {
        return [];
      }

      final contents = await file.readAsString();
      final decoded = jsonDecode(contents);
      if (decoded is! List<dynamic>) {
        debugPrint(
          'PhotoRepository: photos.json has unexpected structure, resetting',
        );
        return [];
      }
      return decoded
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      debugPrint('PhotoRepository: corrupted photos.json, resetting: $e');
      return [];
    }
  }

  Future<List<Photo>> addPhoto(Photo photo) async {
    final doesPhotoAlreadyExist = await getPhotoById(photo.id).then(
      (existing) => existing != null,
    );
    if (doesPhotoAlreadyExist) {
      throw ArgumentError('Photo with id "${photo.id}" already exists');
    }

    final path = await _storagePath;
    final imagesDir = Directory('$path/$_imagesDirName');
    if (!imagesDir.existsSync()) {
      await imagesDir.create(recursive: true);
    }

    final sourceFile = File(photo.imagePath);

    final ext = photo.fileName.contains('.')
        ? photo.fileName.substring(photo.fileName.lastIndexOf('.'))
        : '';
    final storedFileName = '${photo.id}$ext';
    final targetPath = '${imagesDir.path}/$storedFileName';

    await sourceFile.copy(targetPath);

    try {
      final photos = await getPhotos();
      final storedPhoto = photo.copyWith(imagePath: storedFileName);
      photos.add(storedPhoto);
      await _writePhotos(photos);
      return photos;
    } catch (_) {
      final orphan = File(targetPath);
      if (orphan.existsSync()) {
        await orphan.delete();
      }
      rethrow;
    }
  }

  Future<List<Photo>> deletePhoto(String id) async {
    final photos = await getPhotos();
    final index = photos.indexWhere((p) => p.id == id);
    if (index == -1) return photos;

    final photo = photos[index];
    photos.removeAt(index);
    await _writePhotos(photos);

    try {
      final path = await _storagePath;
      final imageFile = File('$path/$_imagesDirName/${photo.imagePath}');
      if (imageFile.existsSync()) {
        await imageFile.delete();
      }
      return photos;
    } on FileSystemException catch (e) {
      debugPrint(
        'PhotoRepository: could not delete the copy of the image for photo $id: $e',
      );
      throw Exception('Failed to delete photo image file');
    }
  }

  Future<Photo?> getPhotoById(String id) async {
    final photos = await getPhotos();
    final matches = photos.where((p) => p.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  Future<void> _writePhotos(List<Photo> photos) async {
    final path = await _storagePath;
    final file = File('$path/$_jsonFileName');
    final jsonList = photos.map((p) => p.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}
