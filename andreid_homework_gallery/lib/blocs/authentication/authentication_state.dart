part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    required this.authStatus,
    required this.blocStatus,
    required this.showEnrollmentChoice,
    required this.requiresSetup,
    this.errorMessage,
  });

  final AuthStatus authStatus;
  final BlocStatus blocStatus;
  final String? errorMessage;
  final bool showEnrollmentChoice;
  final bool requiresSetup;

  factory AuthenticationState.initial() {
    return const AuthenticationState(
      authStatus: AuthStatus.unknown,
      blocStatus: BlocStatus.idle,
      showEnrollmentChoice: false,
      requiresSetup: false,
    );
  }

  AuthenticationState copyWith({
    AuthStatus? authStatus,
    BlocStatus? blocStatus,
    String? Function()? errorMessage,
    bool? showEnrollmentChoice,
    bool? requiresSetup,
  }) {
    bool finalShowEnrollmentChoice =
        showEnrollmentChoice ?? this.showEnrollmentChoice;
    bool finalRequiresSetup = requiresSetup ?? this.requiresSetup;

    if (requiresSetup == true) {
      finalShowEnrollmentChoice = false;
    } else if (showEnrollmentChoice == true) {
      finalRequiresSetup = false;
    }
    return AuthenticationState(
      authStatus: authStatus ?? this.authStatus,
      blocStatus: blocStatus ?? this.blocStatus,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      showEnrollmentChoice: finalShowEnrollmentChoice,
      requiresSetup: finalRequiresSetup,
    );
  }

  @override
  List<Object?> get props => [
    authStatus,
    blocStatus,
    errorMessage,
    showEnrollmentChoice,
    requiresSetup,
  ];
}
