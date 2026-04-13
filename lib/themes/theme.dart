import 'package:flutter/material.dart';

final ThemeData dnTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.white, // важно для Quill и попапов
  cardColor: Colors.white,
  fontFamily: 'Cormorant',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Cormorant',
      fontSize: 20.0,
    ), // основной крупный текст
    bodyMedium: TextStyle(
      fontFamily: 'Cormorant',
      fontSize: 18.0,
    ), // как ты просил
    bodySmall: TextStyle(fontFamily: 'Cormorant', fontSize: 16.0),

    titleLarge: TextStyle(fontFamily: 'Cormorant', fontSize: 24.0),
    titleMedium: TextStyle(fontFamily: 'Cormorant', fontSize: 22.0),
    titleSmall: TextStyle(fontFamily: 'Cormorant', fontSize: 20.0),

    headlineLarge: TextStyle(fontFamily: 'Cormorant', fontSize: 28.0),
    headlineMedium: TextStyle(fontFamily: 'Cormorant', fontSize: 26.0),
    headlineSmall: TextStyle(fontFamily: 'Cormorant', fontSize: 22.0),

    labelLarge: TextStyle(fontFamily: 'Cormorant', fontSize: 20.0),
    labelMedium: TextStyle(fontFamily: 'Cormorant', fontSize: 18.0),
    labelSmall: TextStyle(fontFamily: 'Cormorant', fontSize: 16.0),
  ),
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
