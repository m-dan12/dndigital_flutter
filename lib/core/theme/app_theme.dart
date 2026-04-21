import 'package:dndigital/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData dnTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.white, // важно для Quill и попапов
  cardColor: Colors.white,
  fontFamily: GoogleFonts.lora().fontFamily,
  textTheme: appTextTheme,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    brightness: Brightness.light,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      textStyle: const TextStyle(fontFamily: 'Cormorant', fontSize: 18.0),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      textStyle: const TextStyle(fontFamily: 'Cormorant', fontSize: 18.0),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      textStyle: const TextStyle(fontFamily: 'Cormorant', fontSize: 18.0),
    ),
  ),
  // если используешь IconButton и хочешь тоже закруглить
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      iconSize: 20,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ), // можно настроить отступы
    ),
  ),
);
