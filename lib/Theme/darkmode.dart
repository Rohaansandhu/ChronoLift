import 'package:flutter/material.dart';

// Option 1 — Electric Energy
ThemeData electricEnergyDark = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Color(0xFF0F9DFF), // Electric Blue
    secondary: Color(0xFF1B1B1B), // Dark Slate
    inversePrimary: Colors.grey.shade400,
    tertiary: Colors.white, // Text color
  ),
  textTheme: ThemeData.dark()
      .textTheme
      .apply(bodyColor: Colors.grey[300], displayColor: Colors.white),
);

// Option 2 — Strength & Power
ThemeData strengthPowerDark = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Color(0xFFE53935), // Deep Red
    secondary: Color(0xFF212121), // Charcoal Gray
    inversePrimary: Colors.grey.shade400,
    tertiary: Colors.white,
  ),
  textTheme: ThemeData.dark()
      .textTheme
      .apply(bodyColor: Colors.grey[300], displayColor: Colors.white),
);

// Option 3 — Modern Minimal
ThemeData modernMinimalDark = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Color(0xFF00E676), // Neon Green
    secondary: Color(0xFF000000), // Jet Black
    inversePrimary: Colors.grey.shade400,
    tertiary: Colors.white,
  ),
  textTheme: ThemeData.dark()
      .textTheme
      .apply(bodyColor: Colors.grey[300], displayColor: Colors.white),
);

ThemeData darkmode = electricEnergyDark;
