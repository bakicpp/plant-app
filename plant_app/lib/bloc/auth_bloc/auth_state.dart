import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/bloc/plant_bloc/plant_bloc.dart';
import 'package:plant_app/pages/homepage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:meta/meta.dart';
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
