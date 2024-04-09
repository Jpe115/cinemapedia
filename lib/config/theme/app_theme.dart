import 'package:flutter/material.dart';

class AppTheme{
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 10, 70, 223),
    brightness: Brightness.light,
  );

  ThemeData getDarkTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 10, 70, 223),
    brightness: Brightness.dark
  );
}