import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PasswordVisibilityEvent {}

class TogglePasswordVisibilityEvent extends PasswordVisibilityEvent {}

abstract class PasswordVisibilityState {}

class PasswordVisibleState extends PasswordVisibilityState {}

class PasswordHiddenState extends PasswordVisibilityState {}

class PasswordVisibilityBloc
    extends Bloc<PasswordVisibilityEvent, PasswordVisibilityState> {
  PasswordVisibilityBloc() : super(PasswordHiddenState()) {
    on<TogglePasswordVisibilityEvent>((event, emit) {
      if (state is PasswordHiddenState) {
        emit(PasswordVisibleState());
      } else {
        emit(PasswordHiddenState());
      }
    });
  }
}
