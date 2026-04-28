class PhotoMetadata {
  const PhotoMetadata({
    this.title,
    this.description,
    this.dateTaken,
  });

  final String? title;
  final String? description;
  final DateTime? dateTaken;
}