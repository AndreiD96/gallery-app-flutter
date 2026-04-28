import 'dart:io';

import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/widgets/reusable/photo_placeholder.dart';
import 'package:flutter/material.dart';

class InteractiveImageWidget extends StatelessWidget {
  const InteractiveImageWidget({
    required this.imagePath,
    required this.isFullScreen,
    required this.onIconTap,
    super.key,
  });

  final String? imagePath;
  final bool isFullScreen;
  final void Function(BuildContext context, String? imagePath) onIconTap;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return const SizedBox(
        height: 300,
        child: PhotoPlaceholder(size: AppDimensions.iconXl),
      );
    }

    final maxHeight = MediaQuery.sizeOf(context).height * 0.6;

    return isFullScreen
        ? SafeArea(
            child: Center(
              child: _buildImage(context),
            ),
          )
        : ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: ColoredBox(
              color: AppColors.surfaceContainerHighest,
              child: _buildImage(context),
            ),
          );
  }

  Widget _buildImage(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: isFullScreen ? 0 : null,
          bottom: isFullScreen ? 0 : null,
          left: isFullScreen ? 0 : null,
          right: isFullScreen ? 0 : null,
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 6,
            child: Image.file(
              File(imagePath!),
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => isFullScreen
                  ? const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: AppDimensions.iconXl,
                    )
                  : const SizedBox(
                      height: 300,
                      child: PhotoPlaceholder(size: AppDimensions.iconXl),
                    ),
            ),
          ),
        ),
        Positioned(
          right: isFullScreen ? 0 : AppDimensions.paddingSm,
          bottom: isFullScreen ? null : AppDimensions.paddingSm,
          top: isFullScreen ? 0 : null,
          child: IconButton(
            onPressed: () => onIconTap(context, imagePath),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
            ),
            icon: isFullScreen
                ? const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: AppDimensions.iconMd,
                  )
                : const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: AppDimensions.iconLg,
                  ),
          ),
        ),
      ],
    );
  }
}
