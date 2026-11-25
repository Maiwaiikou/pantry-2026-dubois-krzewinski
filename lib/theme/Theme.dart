import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3F7D58),
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3F7D58),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );

  Color nutriA = const Color(0xFF038141);
  Color nutriB = const Color(0xFF85BB2F);
  Color nutriC = const Color(0xFFFECB02);
  Color nutriD = const Color(0xFFEE8100);
  Color nutriE = const Color(0xFFE63E11);

static Color expirySoonFor(Brightness brightness) {
  return brightness == Brightness.dark
      ? const Color(0xFFFFB77A)
      : const Color(0xFFB25E00);
}

static Color expiryPassedFor(Brightness brightness) {
  return brightness == Brightness.dark
      ? const Color(0xFFFF9C94)
      : const Color(0xFFB3261E);
}
    
}