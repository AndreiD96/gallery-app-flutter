import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.photo_library, size: 64),
        SizedBox(height: AppDimensions.paddingLg),
        Text('Photo Gallery'),
        SizedBox(height: AppDimensions.paddingLg),
        CircularProgressIndicator(),
      ],
    );
  }
}
