import 'dart:async';

import 'package:andreid_homework_gallery/blocs/authentication/authentication_bloc.dart';
import 'package:andreid_homework_gallery/general/constants/app_routes.dart';
import 'package:andreid_homework_gallery/general/enums/auth_status.dart';
import 'package:andreid_homework_gallery/screens/add_photo_screen.dart';
import 'package:andreid_homework_gallery/screens/gallery_screen.dart';
import 'package:andreid_homework_gallery/screens/intro_screen.dart';
import 'package:andreid_homework_gallery/screens/photo_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthenticationBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.intro,
    refreshListenable: _AuthChangeNotifier(authBloc),
    redirect: (context, state) {
      final isAuthenticated =
          authBloc.state.authStatus == AuthStatus.authenticated;
      final onIntro = state.matchedLocation == AppRoutes.intro;

      if (!isAuthenticated && !onIntro) {
        return AppRoutes.intro;
      }

      if (isAuthenticated && onIntro) {
        return AppRoutes.gallery;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.intro,
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: AppRoutes.gallery,
        builder: (context, state) => const GalleryScreen(),
      ),
      GoRoute(
        path: AppRoutes.addPhoto,
        builder: (context, state) => const AddPhotoScreen(),
      ),
      GoRoute(
        path: AppRoutes.photoDetail,
        builder: (context, state) {
          final photoId = state.pathParameters['id'] ?? '';
          return PhotoDetailScreen(photoId: photoId);
        },
      ),
    ],
  );
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(AuthenticationBloc bloc) {
    _subscription = bloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthenticationState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
