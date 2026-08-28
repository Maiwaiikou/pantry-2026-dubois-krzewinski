import 'package:flutter/material.dart';

/// Titre de section de la fiche produit, suivi de son contenu.
///
/// Le titre et l'espacement sont définis une seule fois ici plutôt que répétés
/// à chaque section : la maquette impose les mêmes valeurs partout, et les
/// dupliquer garantit qu'elles finiront par diverger.
class DetailSection extends StatelessWidget {
  const DetailSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// Texte de repli affiché quand une donnée est absente.
///
/// Distinct visuellement d'une vraie valeur : l'utilisateur doit voir que le
/// champ est vide, pas croire qu'il vaut « Non renseignée ».
class MissingValue extends StatelessWidget {
  const MissingValue(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontStyle: FontStyle.italic,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
