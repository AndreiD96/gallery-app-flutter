part of 'add_photo_bloc.dart';

class AddPhotoState extends Equatable {
  const AddPhotoState({
    this.selectedImagePath,
    this.metadata,
    this.blocStatus = BlocStatus.idle,
    this.lastAction = AddPhotoAction.none,
    this.errorMessage,
    this.photoToAdd,
  });

  final String? selectedImagePath;
  final PhotoMetadata? metadata;
  final BlocStatus blocStatus;
  final AddPhotoAction lastAction;
  final String? errorMessage;
  final Photo? photoToAdd;

  bool get isPicking =>
      blocStatus == BlocStatus.loading && lastAction == AddPhotoAction.pick;

  bool get isSaving =>
      blocStatus == BlocStatus.loading && lastAction == AddPhotoAction.save;



  AddPhotoState copyWith({
    String? Function()? selectedImagePath,
    PhotoMetadata? metadata,
    BlocStatus? blocStatus,
    AddPhotoAction? lastAction,
    String?errorMessage,
    Photo? photoToAdd,
  }) {
    return AddPhotoState(
      selectedImagePath: selectedImagePath != null
          ? selectedImagePath()
          : this.selectedImagePath,
      metadata: metadata ?? this.metadata,
      blocStatus: blocStatus ?? this.blocStatus,
      lastAction: lastAction ?? this.lastAction,
      errorMessage: errorMessage ?? this.errorMessage,
      photoToAdd: photoToAdd ?? this.photoToAdd,
    );
  }

  @override
  List<Object?> get props => [
        selectedImagePath,
        metadata,
        blocStatus,
        lastAction,
        errorMessage,
        photoToAdd,
      ];
}
