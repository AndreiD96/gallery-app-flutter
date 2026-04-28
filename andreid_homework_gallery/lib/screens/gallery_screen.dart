import 'package:andreid_homework_gallery/blocs/gallery/gallery_bloc.dart';
import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_routes.dart';
import 'package:andreid_homework_gallery/general/constants/app_text_styles.dart';
import 'package:andreid_homework_gallery/general/enums/bloc_status.dart';
import 'package:andreid_homework_gallery/general/enums/gallery_enums.dart';
import 'package:andreid_homework_gallery/widgets/gallery/photo_grid_widget.dart';
import 'package:andreid_homework_gallery/widgets/gallery/photo_list_widget.dart';
import 'package:andreid_homework_gallery/widgets/reusable/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final GalleryBloc _galleryBloc;

  @override
  void initState() {
    super.initState();
    _galleryBloc = context.read<GalleryBloc>()..add(const GalleryLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          BlocBuilder<GalleryBloc, GalleryState>(
            buildWhen: (previous, current) =>
                previous.viewMode != current.viewMode,
            builder: (context, state) {
              final isGrid = state.viewMode == GalleryViewMode.grid;
              return IconButton(
                icon: Icon(
                  isGrid ? Icons.view_list : Icons.grid_view,
                ),
                onPressed: () => _galleryBloc.add(
                  const GalleryViewModeToggled(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            switch (state.blocStatus) {
              case BlocStatus.loading:
              case BlocStatus.idle:
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              case BlocStatus.failure:
                return CustomErrorWidget(
                  message: state.errorMessage ?? 'Could not load photos',
                  onRetry: () => _galleryBloc.add(const GalleryLoadEvent()),
                );
              case BlocStatus.success when state.photos.isEmpty:
                return _buildEmptyState();
              case BlocStatus.success:
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: state.viewMode == GalleryViewMode.grid
                      ? PhotoGridWidget(
                          photos: state.photos,
                          basePath: state.imagesBasePath,
                        )
                      : PhotoListWidget(
                          photos: state.photos,
                          basePath: state.imagesBasePath,
                        ),
                );
            }
          },
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add photo',
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          onPressed: () => context.push(AppRoutes.addPhoto),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: AppDimensions.iconXl,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            Text(
              'No photos yet',
              style: AppTextStyles.s16w500(),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            Text(
              'Tap the + button to add your first photo',
              style: AppTextStyles.s14w400(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
