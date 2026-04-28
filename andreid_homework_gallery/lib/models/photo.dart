class Photo  {
  const Photo({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.fileName,
    required this.dateAdded,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      fileName: json['fileName'] as String,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
    );
  }

  final String id;
  final String title;
  final String description;
  final String imagePath;
  final String fileName;
  final DateTime dateAdded;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'fileName': fileName,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  String? fullImagePath(String? basePath) {
    if (basePath == null) return null;
    return '$basePath/$imagePath';
  }

  Photo copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    String? fileName,
    DateTime? dateAdded,
  }) {
    return Photo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      fileName: fileName ?? this.fileName,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
