import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_text_styles.dart';
import 'package:andreid_homework_gallery/general/utils/formatter.dart';
import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:flutter/material.dart';

class PhotoMetadataWidget extends StatelessWidget {
  const PhotoMetadataWidget({required this.photo, super.key,});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(photo.title, style: AppTextStyles.s24w400()),
        if (photo.description.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingSm),
          Text(photo.description, style: AppTextStyles.s16w400()),
        ],
        const SizedBox(height: AppDimensions.paddingMd),
        _metadataRow(
          icon: Icons.insert_drive_file,
          label: photo.fileName,
        ),
        const SizedBox(height: AppDimensions.paddingSm),
        _metadataRow(
          icon: Icons.calendar_today,
          label: AppFormatter.formatDate(photo.dateAdded),
        ),
      ],
    );
  }

  Widget _metadataRow({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: AppDimensions.iconSm, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.paddingSm),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.s14w400(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

}
