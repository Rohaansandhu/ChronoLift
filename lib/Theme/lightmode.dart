import 'package:flutter/material.dart';

// Option 1 — Electric Energy
ThemeData electricEnergyLight = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Color(0xFF0F9DFF), // Electric Blue
    secondary: Color(0xFF1B1B1B), // Dark Slate
    inversePrimary: Colors.grey.shade700,
    tertiary: Colors.black, // Text color
  ),
  textTheme: ThemeData.light()
      .textTheme
      .apply(bodyColor: Colors.grey[800], displayColor: Colors.black),
);

// Option 2 — Strength & Power
ThemeData strengthPowerLight = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Color(0xFFE53935), // Deep Red
    secondary: Color(0xFF212121), // Charcoal Gray
    inversePrimary: Colors.grey.shade700,
    tertiary: Colors.black,
  ),
  textTheme: ThemeData.light()
      .textTheme
      .apply(bodyColor: Colors.grey[800], displayColor: Colors.black),
);

// Option 3 — Modern Minimal
ThemeData modernMinimalLight = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Color(0xFF00E676), // Neon Green
    secondary: Color(0xFF000000), // Jet Black
    inversePrimary: Colors.grey.shade700,
    tertiary: Colors.black,
  ),
  textTheme: ThemeData.light()
      .textTheme
      .apply(bodyColor: Colors.grey[800], displayColor: Colors.black),
);

ThemeData lightmode = electricEnergyLight;
