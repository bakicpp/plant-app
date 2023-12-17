// lib/src/bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_app/bloc/plant_bloc.dart';
import 'package:plant_app/pages/homepage.dart';
import 'package:plant_app/repository/plant_repository.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final User user;

  AuthAuthenticatedState(this.user);

  void authSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.leftToRightWithFade,
        child: BlocProvider(
          create: (context) => PlantBloc(PlantRepository()),
          child: const Homepage(),
        ),
      ),
    );
  }
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);

  void showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $errorMessage')),
    );
  }
}

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

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> isUserSignedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

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
      } else if (event is AuthSignUpEvent) {
        try {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          emit(AuthAuthenticatedState(userCredential.user!));
        } catch (e) {
          emit(AuthErrorState("Sign up failed: $e"));
        }
      }
    });
  }
}
