import 'package:equatable/equatable.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';

abstract class EmailAuthState extends Equatable {
  const EmailAuthState();

  @override
  List<Object?> get props => [];
}

class EmailAuthInitial extends EmailAuthState {
  const EmailAuthInitial();
}

class EmailAuthLoading extends EmailAuthState {
  const EmailAuthLoading();
}

class EmailAuthSuccess extends EmailAuthState {
  final UserEntity user;

  const EmailAuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class EmailAuthError extends EmailAuthState {
  final String message;

  const EmailAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResetPasswordSendState extends EmailAuthState {
  final String successMessage;
  final String email;
  const ResetPasswordSendState({
    required this.successMessage,
    required this.email,
  });

  @override
  List<Object?> get props => [successMessage];
}

class VerifyPasswordOtpState extends EmailAuthState {
  const VerifyPasswordOtpState();
  @override
  List<Object?> get props => [];
}

class UpdatePasswordState extends EmailAuthState {
  final String successMessage;
  const UpdatePasswordState({
    required this.successMessage,
  });
  @override
  List<Object?> get props => [successMessage];
}
