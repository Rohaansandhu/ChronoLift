import 'package:flutter/material.dart';

// const textColor = Color(0xFF171717);
// const backgroundColor = Color(0xFFeff1f1);
// const primaryColor = Color(0xFF3b464a);
// const primaryFgColor = Color(0xFFeff1f1);
// const secondaryColor = Color(0xFF9db2b8);
// const secondaryFgColor = Color(0xFF171717);
// const accentColor = Color(0xFF597c88);
// const accentFgColor = Color(0xFFeff1f1);
  
// const colorScheme = ColorScheme(
//   brightness: Brightness.light,
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
//   error: Brightness.light == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
//   onError: Brightness.light == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
// );

// const textColor = Color(0xFF070f05);
// const backgroundColor = Color(0xFFf4fbf3);
// const primaryColor = Color(0xFF58c043);
// const primaryFgColor = Color(0xFF070f05);
// const secondaryColor = Color(0xFF93dbaf);
// const secondaryFgColor = Color(0xFF070f05);
// const accentColor = Color(0xFF72d0ab);
// const accentFgColor = Color(0xFF070f05);

// const colorScheme = ColorScheme(
//   brightness: Brightness.light,
//   surface: backgroundColor,
//   onSurface: textColor,
//   primary: primaryColor,
//   onPrimary: primaryFgColor,
//   secondary: secondaryColor,
//   onSecondary: secondaryFgColor,
//   tertiary: accentColor,
//   onTertiary: accentFgColor,
//   error: Brightness.light == Brightness.light
//       ? Color(0xffB3261E)
//       : Color(0xffF2B8B5),
//   onError: Brightness.light == Brightness.light
//       ? Color(0xffFFFFFF)
//       : Color(0xff601410),
// );

const textColor = Color(0xFF102323);
const backgroundColor = Color(0xFFe8f8f8);
const primaryColor = Color(0xFF1b7879);
const primaryFgColor = Color(0xFFe8f8f8);
const secondaryColor = Color(0xFF78ebed);
const secondaryFgColor = Color(0xFF102323);
const accentColor = Color(0xFF0bbec1);
const accentFgColor = Color(0xFF102323);
  
const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.light == Brightness.light ? Color.fromARGB(255, 214, 70, 62) : Color(0xffF2B8B5),
  onError: Brightness.light == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
);

ThemeData lightmode =
    ThemeData(brightness: Brightness.light, colorScheme: colorScheme);
