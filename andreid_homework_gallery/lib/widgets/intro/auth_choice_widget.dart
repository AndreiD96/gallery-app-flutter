import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class AuthChoiceWidget extends StatelessWidget {
  const AuthChoiceWidget({
    required this.onOpenSettings,
    required this.onUsePin,
    required this.onRetry,
    super.key,});

  final Future<void> Function() onOpenSettings;
  final VoidCallback onUsePin;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.fingerprint,
          size: 64,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.paddingLg),
        const Text(
          'This app requires authentication.\n'
              'No biometrics are enrolled on this device.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingXl),
        FilledButton.icon(
          onPressed: onOpenSettings,
          icon: const Icon(Icons.settings),
          label: const Text('Enable Biometrics'),
        ),
        const SizedBox(height: AppDimensions.paddingSm),
        OutlinedButton.icon(
          onPressed: onUsePin,
          icon: const Icon(Icons.pin),
          label: const Text('Use PIN Instead'),
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        TextButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
