import 'package:flutter_bloc/flutter_bloc.dart';
import 'password_visibility_event.dart';
import 'password_visibility_state.dart';

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
