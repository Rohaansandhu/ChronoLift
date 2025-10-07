import 'package:flutter/material.dart';

// const textColor = Color(0xFFe8e8e8);
// const backgroundColor = Color(0xFF0e1010);
// const primaryColor = Color(0xFFb5c0c4);
// const primaryFgColor = Color(0xFF0e1010);
// const secondaryColor = Color(0xFF475c62);
// const secondaryFgColor = Color(0xFFe8e8e8);
// const accentColor = Color(0xFF779ba6);
// const accentFgColor = Color(0xFF0e1010);
  
// const colorScheme = ColorScheme(
//   brightness: Brightness.dark,
//   background: backgroundColor,
//   onBackground: textColor,
//   primary: primaryColor,
//   onPrimary: primaryFgColor,
//   secondary: secondaryColor,
//   onSecondary: secondaryFgColor,
//   tertiary: accentColor,
//   onTertiary: accentFgColor,
//   surface: backgroundColor,
//   onSurface: textColor,
//   error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
//   onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
// );

// const textColor = Color(0xFFf2faf0);
// const backgroundColor = Color(0xFF050b04);
// const primaryColor = Color(0xFF53bb3e);
// const primaryFgColor = Color(0xFF050b04);
// const secondaryColor = Color(0xFF246b3f);
// const secondaryFgColor = Color(0xFFf2faf0);
// const accentColor = Color(0xFF2f8e68);
// const accentFgColor = Color(0xFF050b04);

// const colorScheme = ColorScheme(
//   brightness: Brightness.dark,
//   primary: primaryColor,
//   onPrimary: primaryFgColor,
//   secondary: secondaryColor,
//   onSecondary: secondaryFgColor,
//   tertiary: accentColor,
//   onTertiary: accentFgColor,
//   surface: backgroundColor,
//   onSurface: textColor,
//   error: Brightness.dark == Brightness.light
//       ? Color(0xffB3261E)
//       : Color(0xffF2B8B5),
//   onError: Brightness.dark == Brightness.light
//       ? Color(0xffFFFFFF)
//       : Color(0xff601410),
// );

const textColor = Color(0xFFddefef);
const backgroundColor = Color(0xFF071616);
const primaryColor = Color(0xFF128889);
const primaryFgColor = Color(0xFF071616);
const secondaryColor = Color(0xFF86e3e4);
const secondaryFgColor = Color(0xFF071616);
const accentColor = Color(0xFF3cf2f4);
const accentFgColor = Color(0xFF071616);
  
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
  error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
  onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
);

ThemeData darkmode =
    ThemeData(brightness: Brightness.dark, colorScheme: colorScheme);
