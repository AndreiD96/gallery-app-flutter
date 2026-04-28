import 'package:andreid_homework_gallery/general/enums/bloc_status.dart';
import 'package:andreid_homework_gallery/general/enums/gallery_enums.dart';
import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:andreid_homework_gallery/models/photo_metadata.dart';
import 'package:andreid_homework_gallery/repositories/photo_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';


part 'gallery_event.dart';

part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc({
    required PhotoRepository photoRepository,
  }) : _photoRepository = photoRepository,
       super(GalleryState.initial()) {
    on<GalleryLoadEvent>(_onLoadEvent);
    on<GalleryPhotoAdded>(_onPhotoAdded);
    on<GalleryPhotoDeleted>(_onPhotoDeleted);
    on<GalleryViewModeToggled>(_onViewModeToggled);
  }

  final PhotoRepository _photoRepository;

  Future<void> _onLoadEvent(
    GalleryLoadEvent event,
    Emitter<GalleryState> emit,
  ) async {
    emit(
      state.copyWith(
        blocStatus: BlocStatus.loading,
        lastAction: GalleryAction.load,
      ),
    );

    try {
      final photos = await _photoRepository.getPhotos();
      final basePath = await _photoRepository.getBaseImagePath();

      emit(
        state.copyWith(
          photos: photos,
          imagesBasePath: basePath,
          blocStatus: BlocStatus.success,
          errorMessage: () => null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          blocStatus: BlocStatus.failure,
          errorMessage: () => 'Could not load photos: $e',
        ),
      );
    }
  }

  Future<void> _onPhotoAdded(
    GalleryPhotoAdded event,
    Emitter<GalleryState> emit,
  ) async {
    if(event.imagePath == null){
      return;
    }

    emit(
      state.copyWith(
        blocStatus: BlocStatus.loading,
        lastAction: GalleryAction.add,
      ),
    );

    final id = const Uuid().v4();
    final fileName = path.basename(event.imagePath!);

    final photo = Photo(
      id: id,
      title: event.title,
      description: event.description ?? '',
      imagePath: event.imagePath!,
      fileName: fileName,
      dateAdded: event.metadata?.dateTaken ?? DateTime.now(),
    );

    try {
      final List<Photo> photos = await _photoRepository.addPhoto(photo);
      emit(
        state.copyWith(
          photos: photos,
          blocStatus: BlocStatus.success,
          errorMessage: () => null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          blocStatus: BlocStatus.failure,
          errorMessage: () => 'Could not save photo: $e',
        ),
      );
      return;
    }
  }

  Future<void> _onPhotoDeleted(
    GalleryPhotoDeleted event,
    Emitter<GalleryState> emit,
  ) async {
    emit(
      state.copyWith(
        blocStatus: BlocStatus.loading,
        lastAction: GalleryAction.delete,
      ),
    );

    try {
      final List<Photo> photos = await _photoRepository.deletePhoto(event.photoId);

      emit(
        state.copyWith(
          photos: photos,
          blocStatus: BlocStatus.success,
          errorMessage: () => null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          blocStatus: BlocStatus.failure,
          errorMessage: () => 'Could not delete photo: $e',
        ),
      );
    }
  }

  void _onViewModeToggled(
      GalleryViewModeToggled event,
      Emitter<GalleryState> emit,
      ) {
    emit(state.copyWith(
      viewMode: switch (state.viewMode) {
        GalleryViewMode.grid => GalleryViewMode.list,
        GalleryViewMode.list => GalleryViewMode.grid,
      },
    ));
  }
}
