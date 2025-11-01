import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final String email;
  final String password;
  final bool obscure;
  final bool remember;
  final bool loading;

  const SignInState({
    this.email = '',
    this.password = '',
    this.obscure = true,
    this.remember = false,
    this.loading = false,
  });

  SignInState copyWith({
    String? email,
    String? password,
    bool? obscure,
    bool? remember,
    bool? loading,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscure: obscure ?? this.obscure,
      remember: remember ?? this.remember,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [email, password, obscure, remember, loading];
}
