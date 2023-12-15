import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

abstract class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);
}

class LightThemeState extends ThemeState {
  LightThemeState() : super(lightTheme);
}

class DarkThemeState extends ThemeState {
  DarkThemeState() : super(darkTheme);
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.white,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.black,
);

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box<bool> themeBox = Hive.box<bool>('theme_box');
  ThemeBloc() : super(LightThemeState()) {
    on<ToggleThemeEvent>((event, emit) {
      emit(state is LightThemeState ? DarkThemeState() : LightThemeState());
      _saveThemeState();
    });
    _loadThemeState();
  }

  void _saveThemeState() {
    themeBox.put('isDarkTheme', state is DarkThemeState);
  }

  void _loadThemeState() {
    final isDarkTheme = themeBox.get('isDarkTheme', defaultValue: false);
    if (isDarkTheme.toString() == 'true') {
      add(ToggleThemeEvent());
    }
  }
}
