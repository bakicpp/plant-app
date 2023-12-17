import 'package:flutter/material.dart';
import 'package:plant_app/bloc/theme_bloc/theme_bloc.dart';

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
