import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_routes.dart';
import 'package:andreid_homework_gallery/models/photo.dart';
import 'package:andreid_homework_gallery/widgets/gallery/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhotoGridWidget extends StatelessWidget {
  const PhotoGridWidget({
    required this.photos,
    required this.basePath,
    super.key,
  });

  final List<Photo> photos;
  final String? basePath;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.gridSpacing),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.gridSpacing,
        mainAxisSpacing: AppDimensions.gridSpacing,
        childAspectRatio: 0.75,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return PhotoCard(
          photo: photo,
          imagePath: photo.fullImagePath(basePath),
          onTap: () => context.push(AppRoutes.photoDetailPath(photo.id)),
        );
      },
    );
  }
}
