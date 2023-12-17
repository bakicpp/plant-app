import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent(this.email, this.password);
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpEvent(this.email, this.password);
}

class AuthSignOutEvent extends AuthEvent {}
