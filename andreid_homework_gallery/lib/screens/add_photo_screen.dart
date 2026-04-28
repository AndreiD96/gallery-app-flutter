import 'package:andreid_homework_gallery/blocs/add_photo/add_photo_bloc.dart';
import 'package:andreid_homework_gallery/blocs/gallery/gallery_bloc.dart';
import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/enums/bloc_status.dart';
import 'package:andreid_homework_gallery/general/enums/gallery_enums.dart';
import 'package:andreid_homework_gallery/general/utils/formatter.dart';
import 'package:andreid_homework_gallery/widgets/add_photo/add_photo_form_widget.dart';
import 'package:andreid_homework_gallery/widgets/reusable/image_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddPhotoScreen extends StatelessWidget {
  const AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddPhotoBloc(),
      child: const _InnerAddPhotoWidget(),
    );
  }
}

class _InnerAddPhotoWidget extends StatefulWidget {
  const _InnerAddPhotoWidget();

  @override
  State<_InnerAddPhotoWidget> createState() => _InnerAddPhotoWidgetState();
}

class _InnerAddPhotoWidgetState extends State<_InnerAddPhotoWidget> {
  late final AddPhotoBloc _addPhotoBloc;
  late final GalleryBloc _galleryBloc;

  @override
  void initState() {
    _addPhotoBloc = context.read<AddPhotoBloc>();
    _galleryBloc = context.read<GalleryBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Photo')),
      body: SafeArea(
        top: false,
        child: BlocConsumer<AddPhotoBloc, AddPhotoState>(
          listenWhen: (previous, current) =>
              previous.blocStatus != current.blocStatus ||
              previous.photoToAdd != current.photoToAdd ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.photoToAdd != null &&
                state.metadata != null &&
                state.blocStatus == BlocStatus.success) {
              _galleryBloc.add(
                GalleryPhotoAdded(
                  imagePath: state.photoToAdd?.imagePath,
                  title: state.photoToAdd?.title ?? 'N/A',
                  description: state.photoToAdd?.description,
                  metadata: state.metadata,
                ),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, addPhotoState) {
            if (addPhotoState.isSaving) {
              return const Center(child: CircularProgressIndicator());
            }

            return BlocListener<GalleryBloc, GalleryState>(
              listenWhen: (previous, current) =>
                  previous.blocStatus != current.blocStatus,
              listener: (context, galleryState) {
                final currentAddPhotoState = context.read<AddPhotoBloc>().state;
                if (currentAddPhotoState.blocStatus != BlocStatus.success &&
                    currentAddPhotoState.lastAction != AddPhotoAction.save) {
                  return;
                }

                if (galleryState.blocStatus == BlocStatus.success) {
                  context.pop();
                } else if (galleryState.blocStatus == BlocStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        galleryState.errorMessage ?? 'Could not save photo',
                      ),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (addPhotoState.selectedImagePath != null) ...[
                      ImagePreviewWidget(
                        imagePath: addPhotoState.selectedImagePath!,
                      ),
                      const SizedBox(height: AppDimensions.paddingSm),
                      TextButton.icon(
                        onPressed: () => _addPhotoBloc.add(
                          const AddPhotoImagePickRequested(),
                        ),
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Change Image'),
                      ),
                      const SizedBox(height: AppDimensions.paddingMd),
                      AddPhotoFormWidget(
                        onSubmit: (title, description) => _addPhotoBloc.add(
                          AddPhotoSubmitted(
                            title: title,
                            description: description,
                          ),
                        ),
                        initialTitle: addPhotoState.metadata?.title,
                        initialDescription: addPhotoState.metadata?.description,
                        dateTaken: AppFormatter.formatDate(
                          addPhotoState.metadata?.dateTaken,
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.maxFinite,
                        height: AppDimensions.imagePreviewHeight,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: AppDimensions.iconXl,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMd),
                      FilledButton.icon(
                        onPressed: () => _addPhotoBloc.add(
                          const AddPhotoImagePickRequested(),
                        ),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Pick Image'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
