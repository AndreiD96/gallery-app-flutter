part of 'add_photo_bloc.dart';

sealed class AddPhotoEvent extends Equatable {
  const AddPhotoEvent();

  @override
  List<Object?> get props => [];
}

final class AddPhotoImagePickRequested extends AddPhotoEvent {
  const AddPhotoImagePickRequested();
}

final class AddPhotoSubmitted extends AddPhotoEvent {
  const AddPhotoSubmitted({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
