part of 'gallery_bloc.dart';

sealed class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

final class GalleryLoadEvent extends GalleryEvent {
  const GalleryLoadEvent();
}

final class GalleryPhotoAdded extends GalleryEvent {
  const GalleryPhotoAdded({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.metadata,
});

  final String? imagePath;
  final String title;
  final String? description;
  final PhotoMetadata? metadata;

  @override
  List<Object?> get props => [imagePath, metadata];
}

final class GalleryPhotoDeleted extends GalleryEvent {
  const GalleryPhotoDeleted(this.photoId);

  final String photoId;

  @override
  List<Object?> get props => [photoId];
}

final class GalleryViewModeToggled extends GalleryEvent {
  const GalleryViewModeToggled();
}




