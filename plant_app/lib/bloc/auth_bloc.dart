// lib/src/bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final User user;

  AuthAuthenticatedState(this.user);
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);
}

@immutable
abstract class AuthEvent {}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent(this.email, this.password);
}

class AuthSignOutEvent extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitialState()) {
    on((event, emit) async {
      if (event is AuthSignInEvent) {
        try {
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          emit(AuthAuthenticatedState(userCredential.user!));
        } catch (e) {
          emit(AuthErrorState("Authentication failed: $e"));
        }
      } else if (event is AuthSignOutEvent) {
        try {
          await _auth.signOut();
          emit(AuthUnauthenticatedState());
        } catch (e) {
          emit(AuthErrorState("Sign out failed: $e"));
        }
      }
    });
  }
}
