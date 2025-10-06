import 'package:flutter/material.dart';

const textColor = Color(0xFF070f05);
const backgroundColor = Color(0xFFf4fbf3);
const primaryColor = Color(0xFF58c043);
const primaryFgColor = Color(0xFF070f05);
const secondaryColor = Color(0xFF93dbaf);
const secondaryFgColor = Color(0xFF070f05);
const accentColor = Color(0xFF72d0ab);
const accentFgColor = Color(0xFF070f05);

const colorScheme = ColorScheme(
  brightness: Brightness.light,
  surface: backgroundColor,
  onSurface: textColor,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  error: Brightness.light == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.light == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);

ThemeData lightmode =
    ThemeData(brightness: Brightness.light, colorScheme: colorScheme);
