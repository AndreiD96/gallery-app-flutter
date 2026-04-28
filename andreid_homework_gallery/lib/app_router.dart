import 'dart:async';

import 'package:andreid_homework_gallery/blocs/authentication/authentication_bloc.dart';
import 'package:andreid_homework_gallery/blocs/gallery/gallery_bloc.dart';
import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/repositories/photo_repository.dart';
import 'package:andreid_homework_gallery/repositories/user_repository.dart';
import 'package:andreid_homework_gallery/services/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late final AuthenticationBloc _authBloc;
  late final GalleryBloc _galleryBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthenticationBloc(userRepository: UserRepository());
    _galleryBloc = GalleryBloc(
      photoRepository: PhotoRepository.instance(),
    );
    _router = createRouter(_authBloc);
  }

  @override
  void dispose() {
    unawaited(_authBloc.close());
    unawaited(_galleryBloc.close());
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _galleryBloc),
      ],
      child: MaterialApp.router(
        title: 'Photo Gallery',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            primaryContainer: AppColors.primaryContainer,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            onSurface: AppColors.onSurface,
            error: AppColors.error,
            outline: AppColors.outline,
          ),
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
        ),
        routerConfig: _router,
      ),
    );
  }
}
