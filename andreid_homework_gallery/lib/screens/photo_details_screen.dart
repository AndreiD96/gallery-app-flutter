import 'dart:async';
import 'dart:io';

import 'package:andreid_homework_gallery/blocs/gallery/gallery_bloc.dart';
import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_routes.dart';
import 'package:andreid_homework_gallery/general/enums/bloc_status.dart';
import 'package:andreid_homework_gallery/general/enums/gallery_enums.dart';
import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:andreid_homework_gallery/widgets/reusable/delete_confirmation_dialog.dart';
import 'package:andreid_homework_gallery/widgets/reusable/interactive_image_widget.dart';
import 'package:andreid_homework_gallery/widgets/reusable/photo_metadata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({required this.photoId, super.key});

  final String photoId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GalleryBloc, GalleryState>(
      listenWhen: (previous, current) {
        if (current.lastAction != GalleryAction.delete) {
          return false;
        }

        final hadPhoto = previous.photos.any((p) => p.id == photoId);
        final hasPhoto = current.photos.any((p) => p.id == photoId);
        if (hadPhoto && !hasPhoto && current.blocStatus == BlocStatus.success) {
          return true;
        }

        if (current.blocStatus == BlocStatus.failure &&
            current.lastAction == GalleryAction.delete) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.blocStatus == BlocStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Could not delete photo'),
            ),
          );
          return;
        }

        context.go(AppRoutes.gallery);
      },
      builder: (context, state) {
        final photo = _findPhoto(state);

        if (photo == null) {
          return _buildEmptyOrFailureWidget(context);
        }

        final imagePath = photo.fullImagePath(state.imagesBasePath);

        return Scaffold(
          appBar: AppBar(
            title: Text(photo.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _onDelete(context, photo),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InteractiveImageWidget(
                    imagePath: imagePath,
                    isFullScreen: false,
                    onIconTap: _openFullScreen,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    child: PhotoMetadataWidget(
                      photo: photo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyOrFailureWidget(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Detail')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.image_not_supported,
              size: AppDimensions.iconXl,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            const Text('Photo not found'),
            const SizedBox(height: AppDimensions.paddingMd),
            FilledButton(
              onPressed: () => context.go(AppRoutes.gallery),
              child: const Text('Back to Gallery'),
            ),
          ],
        ),
      ),
    );
  }

  Photo? _findPhoto(GalleryState state) {
    final matches = state.photos.where((p) => p.id == photoId);
    return matches.isEmpty ? null : matches.first;
  }

  void _openFullScreen(BuildContext context, String? imagePath) {
    if (imagePath == null || !File(imagePath).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image file not found')),
      );
      return;
    }

    unawaited(
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Close full screen image',
        barrierColor: Colors.black,
        pageBuilder: (_, _, _) => InteractiveImageWidget(
          imagePath: imagePath,
          isFullScreen: true,
          onIconTap: (context, imagePath) {
            context.pop();
          },
        ),
      ),
    );
  }

  Future<void> _onDelete(BuildContext context, Photo photo) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      photoTitle: photo.title,
    );

    if (confirmed == true && context.mounted) {
      context.read<GalleryBloc>().add(GalleryPhotoDeleted(photo.id));
    }
  }
}
