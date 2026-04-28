import 'package:andreid_homework_gallery/blocs/authentication/authentication_bloc.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/enums/auth_status.dart';
import 'package:andreid_homework_gallery/general/enums/bloc_status.dart';
import 'package:andreid_homework_gallery/widgets/intro/auth_choice_widget.dart';
import 'package:andreid_homework_gallery/widgets/reusable/custom_error_widget.dart';
import 'package:andreid_homework_gallery/widgets/reusable/loading_widget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final AuthenticationBloc _authBloc;

  @override
  void initState() {
    _authBloc = context.read<AuthenticationBloc>()
      ..add(
        const AuthCheckRequested(),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.showEnrollmentChoice) {
                  return AuthChoiceWidget(
                    onOpenSettings: () => _openSecuritySettings(context),
                    onUsePin: () => _authBloc.add(
                      const AuthUsePinRequested(),
                    ),
                    onRetry: () => _authBloc.add(
                      const AuthRetryRequested(),
                    ),
                  );
                }

                if (state.requiresSetup) {
                  return CustomErrorWidget(
                    isWarning: true,
                    isSetupRequiredWarning: true,
                    onOpenSettings: () => _openSecuritySettings(context),
                    onRetry: () => context.read<AuthenticationBloc>().add(
                      const AuthRetryRequested(),
                    ),
                    message:
                        'No authentication method available.\n'
                        'Please enable biometrics or screen lock\n'
                        'in your device settings.',
                  );
                }

                switch (state.blocStatus) {
                  case BlocStatus.failure:
                    return CustomErrorWidget(
                      message: state.errorMessage ?? 'Authentication failed.',
                      onRetry: () => _authBloc.add(
                        const AuthRetryRequested(),
                      ),
                    );
                  case BlocStatus.success
                      when state.authStatus == AuthStatus.unavailable:
                    return const CustomErrorWidget(
                      isWarning: true,
                      message:
                          'Biometrics not available on this device.\n'
                          'Access granted without authentication.',
                    );

                  case BlocStatus.idle:
                  case BlocStatus.loading:
                  case BlocStatus.success:
                    return const LoadingWidget();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openSecuritySettings(BuildContext context) async {
  try {
    await AppSettings.openAppSettings(type: AppSettingsType.security);
  } on Exception {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open settings. Please open them manually.'),
        ),
      );
    }
  }
}
