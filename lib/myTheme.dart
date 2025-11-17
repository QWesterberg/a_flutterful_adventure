import 'package:flutter/material.dart';

ThemeData getTheme(Brightness newBrightness, Color newSeedColor) {
  var scheme = ColorScheme.fromSeed(
    seedColor: newSeedColor,
    brightness: newBrightness,
  );

  //scheme = scheme.copyWith(onPrimary: Colors.black);

  return ThemeData(
    //color scheme
    colorScheme: scheme,

    //bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: scheme.onPrimary,
      ),
    ),

    //for elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),

    //text theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: scheme.primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: scheme.secondary,
      ),
    ),

    //card theme
    cardTheme: CardThemeData(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.all(16),
    ),
  );
}
