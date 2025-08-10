import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Color(0xFFFCF6F5),
      primary: Color(0xCC990011),
      secondary: Color(0xFFFFD6A5),
      inversePrimary: Colors.grey.shade700,
      // USED FOR TEXT
      tertiary: Colors.black,

    ),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: Colors.grey[800], displayColor: Colors.black));