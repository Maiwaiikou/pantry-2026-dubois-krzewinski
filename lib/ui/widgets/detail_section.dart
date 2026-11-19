import 'package:flutter/material.dart';


class DetailSection extends StatelessWidget{
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
          style : theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: theme.colorScheme.onSurfaceVariant,
          )
        ), 
        const SizedBox(height: 8),
        child
      ]
    );
  }
}

class MissingValue extends StatelessWidget{
  const MissingValue(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic
      ),
    );
  }
}