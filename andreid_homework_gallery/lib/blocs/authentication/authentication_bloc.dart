import 'package:andreid_homework_gallery/general/enums/auth_status.dart';
import 'package:andreid_homework_gallery/general/enums/bloc_status.dart';
import 'package:andreid_homework_gallery/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required UserRepository userRepository,
    LocalAuthentication? localAuth,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       _userRepository = userRepository,
       super(AuthenticationState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthRetryRequested>(_onAuthRetryRequested);
    on<AuthUsePinRequested>(_onAuthUsePinRequested);
  }

  final LocalAuthentication _localAuth;
  final UserRepository _userRepository;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      state.copyWith(
        blocStatus: BlocStatus.loading,
      ),
    );

    try {
      final areBiometricAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!areBiometricAvailable && !isDeviceSupported) {
        emit(
          state.copyWith(
            blocStatus: BlocStatus.success,
            authStatus: AuthStatus.unavailable,
          ),
        );

        await Future<void>.delayed(const Duration(seconds: 2));
        if (!isClosed) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.authenticated,
              blocStatus: BlocStatus.success,
            ),
          );
        }
        return;
      }

      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty && areBiometricAvailable) {
        final pinFallbackChosen = await _userRepository.getPinFallbackChosen();

        if (pinFallbackChosen) {
          await _attemptDeviceAuth(emit);
        } else {
          emit(
            state.copyWith(
              authStatus: AuthStatus.unauthenticated,
              blocStatus: BlocStatus.failure,
              showEnrollmentChoice: true,
              requiresSetup: false,
              errorMessage: () => null,
            ),
          );
        }
        return;
      }else {
        await _attemptDeviceAuth(emit);
      }
    } catch (e) {
      emit(
        state.copyWith(
          blocStatus: BlocStatus.failure,
          authStatus: AuthStatus.unauthenticated,
        ),
      );
    }
  }

    Future<void> _onAuthRetryRequested(
      AuthRetryRequested event,
      Emitter<AuthenticationState> emit,
    ) async {
      emit(
        state.copyWith(
          blocStatus: BlocStatus.idle,
          errorMessage: () => null,
          showEnrollmentChoice: false,
          requiresSetup: false,
        ),
      );
      add(const AuthCheckRequested());
    }

  Future<void> _onAuthUsePinRequested(
    AuthUsePinRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      state.copyWith(
        blocStatus: BlocStatus.loading,
        showEnrollmentChoice: false,
      ),
    );

    await _userRepository.setPinFallbackChosen(value: true);

    await _attemptDeviceAuth(emit);
  }


  Future<void> _attemptDeviceAuth(
      Emitter<AuthenticationState> emit,
      ) async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the gallery',
      );

      if (didAuthenticate) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.authenticated,
            blocStatus: BlocStatus.success,
            errorMessage: () => null,
            showEnrollmentChoice: false,
            requiresSetup: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            authStatus: AuthStatus.unauthenticated,
            blocStatus: BlocStatus.failure,
            requiresSetup: true,
            showEnrollmentChoice: false,
            errorMessage: () =>
            'This app requires authentication. Please enable biometrics '
                'or screen lock in your device settings.',
          ),
        );
      }
    } on LocalAuthException catch (e) {
      debugPrint('LocalAuthException: ${e.code} - ${e}');
      emit(
        state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          blocStatus: BlocStatus.failure,
          requiresSetup: true,
          showEnrollmentChoice: false,
          errorMessage: () =>
          'No authentication method available. '
              'Please enable biometrics or screen lock '
              'in your device settings.',
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          blocStatus: BlocStatus.failure,
          errorMessage: () => 'Unexpected error: $e',
          showEnrollmentChoice: false,
          requiresSetup: false,
        ),
      );
    }
  }
}
