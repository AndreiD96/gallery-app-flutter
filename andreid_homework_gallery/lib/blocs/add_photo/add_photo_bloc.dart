import 'package:andreid_homework_gallery/general/enums/bloc_status.dart';
import 'package:andreid_homework_gallery/general/enums/gallery_enums.dart';
import 'package:andreid_homework_gallery/general/utils/exif_metadata.dart';
import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:andreid_homework_gallery/models/photo_metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'add_photo_event.dart';

part 'add_photo_state.dart';

class AddPhotoBloc extends Bloc<AddPhotoEvent, AddPhotoState> {
  AddPhotoBloc() : super(const AddPhotoState()) {
    on<AddPhotoImagePickRequested>(_onImagePickRequested);
    on<AddPhotoSubmitted>(_onSubmitted);
  }

  Future<void> _onImagePickRequested(
    AddPhotoImagePickRequested event,
    Emitter<AddPhotoState> emit,
  ) async {
    if (state.isPicking) return;

    emit(
      state.copyWith(
        blocStatus: BlocStatus.loading,
        lastAction: AddPhotoAction.pick,
      ),
    );

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        emit(state.copyWith(blocStatus: BlocStatus.idle));
        return;
      }

      final metadata = await extractPhotoMetadata(image.path);

      emit(
        state.copyWith(
          selectedImagePath: () => image.path,
          metadata: metadata,
          blocStatus: BlocStatus.idle,
        ),
      );
    } on PlatformException catch (e) {
      final message = e.code == 'photo_access_denied'
          ? 'Gallery access needed to select photos'
          : 'Could not open image picker: ${e.message}';

      emit(
        state.copyWith(
          blocStatus: BlocStatus.failure,
          lastAction: AddPhotoAction.pick,
          errorMessage: message,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    AddPhotoSubmitted event,
    Emitter<AddPhotoState> emit,
  ) async {
    if (state.isSaving || state.photoToAdd != null) return;

    final imagePath = state.selectedImagePath;
    if (imagePath == null) return;

    emit(
      state.copyWith(
        blocStatus: BlocStatus.loading,
        lastAction: AddPhotoAction.save,
      ),
    );

    final id = const Uuid().v4();
    final fileName = p.basename(imagePath);

    final photo = Photo(
      id: id,
      title: event.title,
      description: event.description,
      imagePath: imagePath,
      fileName: fileName,
      dateAdded: state.metadata?.dateTaken ?? DateTime.now(),
    );

    emit(
      state.copyWith(
        blocStatus: BlocStatus.success,
        lastAction: AddPhotoAction.save,
        photoToAdd: photo,
      ),
    );
  }
}
