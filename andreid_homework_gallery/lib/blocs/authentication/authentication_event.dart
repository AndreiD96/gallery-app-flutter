part of 'authentication_bloc.dart';


sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

final class AuthCheckRequested extends AuthenticationEvent {
  const AuthCheckRequested();
}

final class AuthRetryRequested extends AuthenticationEvent {
  const AuthRetryRequested();
}

final class AuthUsePinRequested extends AuthenticationEvent {
  const AuthUsePinRequested();
}
