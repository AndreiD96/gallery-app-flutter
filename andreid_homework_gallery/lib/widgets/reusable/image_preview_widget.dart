import 'dart:io';

import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({required this.imagePath, super.key});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Image.file(
        File(imagePath),
        width: double.infinity,
        height: AppDimensions.imagePreviewHeight,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: AppDimensions.imagePreviewHeight,
            color: AppColors.surfaceContainerHighest,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: AppDimensions.iconLg,
              ),
            ),
          );
        },
      ),
    );
  }
}
