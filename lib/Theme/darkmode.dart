import 'package:flutter/material.dart';

const textColor = Color(0xFFf2faf0);
const backgroundColor = Color(0xFF050b04);
const primaryColor = Color(0xFF53bb3e);
const primaryFgColor = Color(0xFF050b04);
const secondaryColor = Color(0xFF246b3f);
const secondaryFgColor = Color(0xFFf2faf0);
const accentColor = Color(0xFF2f8e68);
const accentFgColor = Color(0xFF050b04);

const colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.dark == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.dark == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);

ThemeData darkmode =
    ThemeData(brightness: Brightness.dark, colorScheme: colorScheme);
