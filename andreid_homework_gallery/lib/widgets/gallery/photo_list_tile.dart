import 'dart:io';

import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_text_styles.dart';
import 'package:andreid_homework_gallery/general/utils/formatter.dart';
import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:andreid_homework_gallery/widgets/reusable/photo_placeholder.dart';
import 'package:flutter/material.dart';

class PhotoListTile extends StatelessWidget {
  const PhotoListTile({
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
    return Semantics(
      label: 'Photo: ${photo.title}',
      button: true,
      child: Card(
        elevation: AppDimensions.tileElevation,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        surfaceTintColor: AppColors.surfaceContainerLow,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SizedBox(
                width: AppDimensions.listThumbnailSize,
                height: AppDimensions.listThumbnailSize,
                child: _buildThumbnail(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSm,
                    vertical: AppDimensions.paddingXs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        photo.title,
                        style: AppTextStyles.s14w500(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (photo.description.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.paddingXs),
                        Text(
                          photo.description,
                          style: AppTextStyles.s12w500(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppDimensions.paddingXs),
                      Text(
                        AppFormatter.formatDate(photo.dateAdded),
                        style: AppTextStyles.s12w500(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
