import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    required this.message,
    this.isWarning = false,
    this.isSetupRequiredWarning = false,
    this.onRetry,
    this.onOpenSettings,
    super.key,
  });

  final bool isWarning;
  final bool isSetupRequiredWarning;
  final String message;
  final VoidCallback? onRetry;
  final Future<void> Function()? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isWarning ? Icons.warning_amber_rounded : Icons.error_outline,
          size: AppDimensions.iconXl,
          color: isWarning ? AppColors.warning : AppColors.error,
        ),
        const SizedBox(height: AppDimensions.paddingLg),
        Text(
          message,
          style: AppTextStyles.s16w400(),
          textAlign: TextAlign.center,
        ),
        if (!isWarning && onRetry != null) ...[
          const SizedBox(height: AppDimensions.paddingLg),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ] else if (isSetupRequiredWarning &&
            onOpenSettings != null &&
            onRetry != null) ...[
          const SizedBox(height: AppDimensions.paddingXl),
          FilledButton.icon(
            onPressed: onOpenSettings,
            icon: const Icon(Icons.settings),
            label: const Text('Open Settings'),
          ),
          const SizedBox(height: AppDimensions.paddingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ],
    );
  }
}
