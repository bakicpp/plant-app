import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

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
