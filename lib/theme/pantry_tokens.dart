import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

@immutable
class PantryTokens extends ThemeExtension<PantryTokens>{
  const PantryTokens({
    required this.nutriA,
    required this.nutriB,
    required this.nutriC,
    required this.nutriD,
    required this.nutriE,
    required this.expirySoon,
    required this.expiryPassed,
    required this.sectionGap,
  });

  final Color nutriA;
  final Color nutriB;
  final Color nutriC;
  final Color nutriD;
  final Color nutriE;

  /// Péremption dans sept jours ou moins.
  final Color expirySoon;

  /// Date de péremption dépassée.
  final Color expiryPassed;

  /// Espacement entre deux sections de la fiche produit.
  final double sectionGap;

  Color? forGrade(String? grade) => switch(grade?.toLowerCase()) {
    'a' => nutriA,
    'b' => nutriB,
    'c' => nutriC,
    'd' => nutriD,
    'e' => nutriE,
    _ => null,
  };

  List<(String, Color)> get gradeScale => [
    ('A', nutriA),
    ('B', nutriB),
    ('C', nutriC),
    ('D', nutriD),
    ('E', nutriE),
  ];

  @override
  PantryTokens copyWith({
    Color? nutriA,
    Color? nutriB,
    Color? nutriC,
    Color? nutriD,
    Color? nutriE,
    Color? expirySoon,
    Color? expiryPassed,
    double? sectionGap,
  }) {
    return PantryTokens(
      nutriA: nutriA ?? this.nutriA,
      nutriB: nutriB ?? this.nutriB,
      nutriC: nutriC ?? this.nutriC,
      nutriD: nutriD ?? this.nutriD,
      nutriE: nutriE ?? this.nutriE,
      expirySoon: expirySoon ?? this.expirySoon,
      expiryPassed: expiryPassed ?? this.expiryPassed,
      sectionGap: sectionGap ?? this.sectionGap,
    );
  }

  @override
  PantryTokens lerp(PantryTokens? other, double t) {
    if(other == null) return this;
    return PantryTokens(
      nutriA: Color.lerp(nutriA, other.nutriA, t)!,
      nutriB: Color.lerp(nutriB, other.nutriB, t)!,
      nutriC: Color.lerp(nutriC, other.nutriC, t)!,
      nutriD: Color.lerp(nutriD, other.nutriD, t)!,
      nutriE: Color.lerp(nutriE, other.nutriE, t)!,
      expirySoon: Color.lerp(expirySoon, other.expirySoon, t)!,
      expiryPassed: Color.lerp(expiryPassed, other.expiryPassed, t)!,
      sectionGap: lerpDouble(sectionGap, other.sectionGap, t)!,
    );
  }
}