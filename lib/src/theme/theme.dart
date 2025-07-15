import "package:flutter/material.dart";

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    splashColor: Colors.grey.shade900,
    dividerColor: Colors.grey.shade300,
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade200,
      primary: Colors.grey.shade800,
      secondary: Colors.amber.shade700,
      tertiary: Colors.amber.shade900,
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    splashColor: Colors.grey.shade200,
    dividerColor: Colors.grey.shade300,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade800,
      primary: Colors.grey.shade200,
      secondary: Colors.amber.shade700,
      tertiary: Colors.amber.shade900,
    ));
