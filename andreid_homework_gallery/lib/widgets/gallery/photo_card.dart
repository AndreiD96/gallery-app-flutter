import 'dart:io';

import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_text_styles.dart';
import 'package:andreid_homework_gallery/general/utils/formatter.dart';
import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:andreid_homework_gallery/widgets/reusable/photo_placeholder.dart';
import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    required this.photo,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  final Photo photo;
  final String? imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.cardElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildThumbnail()),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.title,
                    style: AppTextStyles.s14w500(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXs),
                  Text(
                    AppFormatter.formatDate(photo.dateAdded),
                    style: AppTextStyles.s12w500(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (imagePath == null) {
      return const PhotoPlaceholder();
    }

    return Image.file(
      File(imagePath!),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const PhotoPlaceholder(),
    );
  }
}
