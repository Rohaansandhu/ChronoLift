import 'package:flutter/material.dart';

ThemeData darkmode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade800,
      primary: Color(0xCC990011),
      secondary: Color(0xFFFFD6A5),
      inversePrimary: Colors.grey.shade400,
      // USED FOR TEXT
      tertiary: Colors.white,

    ),
    textTheme: ThemeData.dark()
        .textTheme
        .apply(bodyColor: Colors.grey[300], displayColor: Colors.white));