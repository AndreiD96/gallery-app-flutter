import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    this.size = AppDimensions.iconLg,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: size,
          color: AppColors.textSecondary,
          semanticLabel: 'Image not available',
        ),
      ),
    );
  }
}
