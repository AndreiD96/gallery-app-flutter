import 'dart:io';

import 'package:andreid_homework_gallery/models/photo_metadata.dart';
import 'package:exif/exif.dart';
import 'package:path/path.dart' as path;

const titleExifTag = 'Image ImageDescription';
const descriptionExifTag = 'EXIF UserComment';
const dateExifTags = [
  'EXIF DateTimeOriginal',
  'EXIF DateTimeDigitized',
  'Image DateTime',
];

Future<PhotoMetadata> extractPhotoMetadata(String filePath) async {
  String? title;
  String? description;
  DateTime? dateTaken;

  try {
    final bytes = await File(filePath).readAsBytes();
    final exif = await readExifFromBytes(bytes);

    title = _readTag(exif, titleExifTag);
    description = _readTag(exif, descriptionExifTag);
    dateTaken = _parseExifDate(exif);
  } on Exception {
    title = null;
    description = null;
    dateTaken = null;
  }

  title ??= _titleFromFilename(filePath);

  return PhotoMetadata(
    title: title,
    description: description,
    dateTaken: dateTaken,
  );
}

String? _readTag(Map<String, IfdTag> tags, String key) {
  final tag = tags[key];
  if (tag == null) return null;
  final value = tag.toString().trim();
  return value.isEmpty ? null : value;
}

DateTime? _parseExifDate(Map<String, IfdTag> tags) {
  for (final key in dateExifTags) {
    final raw = _readTag(tags, key);
    if (raw == null) continue;

    final parsedDate = _parseExifDateString(raw);
    if (parsedDate != null) return parsedDate;
  }

  return null;
}

DateTime? _parseExifDateString(String raw) {
  final parts = raw.split(' ');
  if (parts.length != 2) return null;

  final dateParts = parts[0].split(':');
  final timeParts = parts[1].split(':');

  if (dateParts.length != 3 || timeParts.length != 3) return null;

  try {
    return DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );
  } on FormatException {
    return null;
  }
}

String _titleFromFilename(String filePath) {
  final name = path.basenameWithoutExtension(filePath);
  return name.replaceAll(RegExp('[]'), ' ').trim();
}
