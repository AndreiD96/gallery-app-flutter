part of 'gallery_bloc.dart';

class GalleryState extends Equatable {
  const GalleryState({
    required this.photos,
    required this.blocStatus,
    required this.lastAction,
    required this.viewMode,
    this.errorMessage,
    this.imagesBasePath,
  });

  factory GalleryState.initial() => const GalleryState(
    photos: [],
    blocStatus: BlocStatus.idle,
    lastAction: GalleryAction.none,
    viewMode: GalleryViewMode.grid,
  );

  final List<Photo> photos;
  final BlocStatus blocStatus;
  final String? errorMessage;
  final String? imagesBasePath;
  final GalleryAction lastAction;
  final GalleryViewMode viewMode;


  GalleryState copyWith({
    List<Photo>? photos,
    BlocStatus? blocStatus,
    String? Function()? errorMessage,
    String? imagesBasePath,
    GalleryAction? lastAction,
    GalleryViewMode? viewMode,
  }) {
    return GalleryState(
      photos: photos ?? this.photos,
      blocStatus: blocStatus ?? this.blocStatus,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      imagesBasePath: imagesBasePath ?? this.imagesBasePath,
      lastAction: lastAction ?? this.lastAction,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  List<Object?> get props => [
    photos,
    blocStatus,
    errorMessage,
    imagesBasePath,
    lastAction,
    viewMode,
  ];
}
