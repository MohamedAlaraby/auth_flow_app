import 'dart:async';

import 'package:auth_flow_app/features/auth/domain/repositories/email_auth_repository.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final EmailAuthRepository emailAuthRepository;

  EmailAuthBloc({required this.emailAuthRepository}) : super(const EmailAuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SendPasswordRestOtpEvent>(_onResetPassword);
    on<VerifyPasswordRestOtpEvent>(_onVerifyPasswordRestOtp);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<SendMagicLinkEvent>(_onSendMagicLink);
  }

  Future<void> _onSignUpWithEmail(SignUpWithEmailEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      name: event.name,
    );

    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (user) => emit(EmailAuthSuccess(user: user)),
    );
  }

  Future<void> _onSignInWithEmail(SignInWithEmailEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.signInWithEmail(email: event.email, password: event.password);

    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (user) => emit(EmailAuthSuccess(user: user)),
    );
  }

  Future<void> _onResetPassword(SendPasswordRestOtpEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.resetPassword(email: event.email);

    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (_) => emit(PasswordResetOtpSent(message: 'Reset Code Send to ${event.email}', email: event.email)),
    );
  }

  FutureOr<void> _onVerifyPasswordRestOtp(VerifyPasswordRestOtpEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.verifyPasswordRestOtp(email: event.email, otp: event.otp);

    result.fold(
      (failure) {
        emit(EmailAuthError(message: failure.message));
      },
      (_) {
        emit(PasswordResetOtpVerify());
      },
    );
  }

  FutureOr<void> _onUpdatePassword(UpdatePasswordEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.updatePassword(password: event.password);

    result.fold(
      (failure) {
        emit(EmailAuthError(message: failure.message));
      },
      (_) {
        emit(const PasswordUpdated(message: 'Password updated successfully'));
      },
    );
  }

  Future<void> _onSendMagicLink(SendMagicLinkEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.sendMagicLink(email: event.email);

    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (_) => emit(PasswordResetOtpSent(message: 'Magic link sent to your email', email: event.email)),
    );
  }
}
