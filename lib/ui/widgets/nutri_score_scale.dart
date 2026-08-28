import 'package:flutter/material.dart';

/// Échelle Nutri-Score, de A à E, avec mise en avant de la lettre du produit.
///
/// Les cinq teintes sont normalisées par le dispositif Nutri-Score : c'est
/// l'exception admise aux couleurs du thème. Le gris des lettres non
/// sélectionnées est en revanche une couleur en dur ; la séance 3 montre ce
/// que le mode sombre en fait.
class NutriScoreScale extends StatelessWidget {
  const NutriScoreScale({required this.grade, super.key});

  /// Lettre du produit, en minuscule. `null` si le produit n'a pas été évalué.
  final String? grade;

  static const _grades = <String, Color>{
    'a': Color(0xFF038141),
    'b': Color(0xFF85BB2F),
    'c': Color(0xFFFECB02),
    'd': Color(0xFFEE8100),
    'e': Color(0xFFE63E11),
  };

  @override
  Widget build(BuildContext context) {
    final selected = grade?.toLowerCase();

    return Row(
      children: [
        for (final entry in _grades.entries)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _GradeBox(
              letter: entry.key.toUpperCase(),
              color: entry.value,
              isSelected: entry.key == selected,
            ),
          ),
      ],
    );
  }
}

class _GradeBox extends StatelessWidget {
  const _GradeBox({
    required this.letter,
    required this.color,
    required this.isSelected,
  });

  final String letter;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // Sur un fond jaune, du texte blanc est illisible : la couleur du texte
    // se choisit d'après la luminosité du fond, entre deux valeurs fixes.
    final onColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : const Color(0xFF2E332E);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: isSelected ? 44 : 36,
      height: isSelected ? 48 : 40,
      decoration: BoxDecoration(
        color: isSelected ? color : color.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(isSelected ? 7 : 6),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: isSelected ? 21 : 17,
          fontWeight: FontWeight.w700,
          color: isSelected ? onColor : const Color(0xFF2E332E),
        ),
      ),
    );
  }
}
