

import 'package:flutter/material.dart';
import 'package:pantry/theme/pantry_tokens.dart';

abstract final class PantryTheme{

  static const seedColor = Color(0xFF3F7D58);

  static ThemeData get light => _build(Brightness.light, _lightTokens);
  static ThemeData get dark => _build(Brightness.dark, _darkTokens);

  static ThemeData _build(Brightness brightness, PantryTokens tokens){
    final scheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      extensions: [tokens],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      )
    );
  }

  static const _nutriA = Color(0xFF038141);
  static const _nutriB = Color(0xFF85BB2F);
  static const _nutriC = Color(0xFFFECB02);
  static const _nutriD = Color(0xFFEE8100);
  static const _nutriE = Color(0xFFE63E11);

  static const _lightTokens = PantryTokens(
    nutriA: _nutriA,
    nutriB: _nutriB,
    nutriC: _nutriC,
    nutriD: _nutriD,
    nutriE: _nutriE,
    expirySoon: Color(0xFFB25E00),
    expiryPassed: Color(0xFFB3261E),
    sectionGap: 24,
  );

  static const _darkTokens = PantryTokens(
    nutriA: _nutriA,
    nutriB: _nutriB,
    nutriC: _nutriC,
    nutriD: _nutriD,
    nutriE: _nutriE,
    // Les mêmes rouge et orange seraient illisibles sur fond sombre : les
    // versions claires portent le même sens avec un contraste suffisant.
    expirySoon: Color(0xFFFFB77A),
    expiryPassed: Color(0xFFFF9C94),
    sectionGap: 24,
  );
}