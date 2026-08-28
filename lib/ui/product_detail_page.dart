import 'package:flutter/material.dart';

import 'package:pantry/models/product.dart';
import 'package:pantry/ui/widgets/detail_section.dart';
import 'package:pantry/ui/widgets/nutri_score_scale.dart';
import 'package:pantry/ui/widgets/product_image_placeholder.dart';

/// Écran « fiche produit », conforme à `design/fiche-produit.svg`.
///
/// Le point structurant de cet écran n'est pas la mise en page mais le
/// traitement des champs absents : chaque bloc décide de s'afficher, de se
/// remplacer par un texte de repli, ou de disparaître. Les six produits mockés
/// couvrent ces trois cas.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    required this.product,
    required this.onProductRequested,
    required this.availableProducts,
    super.key,
  });

  final Product product;
  final List<Product> availableProducts;
  final ValueChanged<Product> onProductRequested;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche produit'),
        actions: [
          PopupMenuButton<Product>(
            tooltip: 'Changer de produit',
            icon: const Icon(Icons.swap_horiz),
            onSelected: onProductRequested,
            itemBuilder: (context) => [
              for (final p in availableProducts)
                PopupMenuItem(value: p, child: Text(p.displayName)),
            ],
          ),
        ],
      ),
      // ListView plutôt que Column : la fiche doit défiler dès que la fenêtre
      // est basse. Une Column déborderait et afficherait le bandeau rayé.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Header(product: product),
          const _SectionDivider(),
          DetailSection(
            title: 'Nutri-Score',
            child: product.nutriScore == null
                ? const MissingValue('Non évalué')
                : NutriScoreScale(grade: product.nutriScore),
          ),
          const _SectionDivider(),
          DetailSection(
            title: 'Catégories',
            child: product.categories.isEmpty
                ? const MissingValue('Aucune catégorie renseignée')
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in product.categories) Chip(label: Text(c)),
                    ],
                  ),
          ),
          const _SectionDivider(),
          DetailSection(
            title: 'Code-barres',
            child: Text(
              product.barcode,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 24),
          DetailSection(
            title: 'Péremption',
            child: product.expiresOn == null
                ? const MissingValue('Non renseignée')
                : Text(_formatDate(product.expiresOn!)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Formatage manuel, volontairement.
  ///
  /// Le paquet `intl` formaterait la date selon la locale, sujet de la
  /// séance 10.
  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImagePlaceholder(initial: product.initial),
        const SizedBox(width: 16),
        // Expanded est indispensable : sans lui, la Column reçoit une
        // contrainte de largeur non bornée et le nom long déborde au lieu
        // d'être tronqué. C'est le cas d'école du modèle de contraintes.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.displayName,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Les champs absents ne laissent pas de ligne vide : le widget
              // n'est pas construit du tout.
              if (product.brand != null) ...[
                const SizedBox(height: 4),
                Text(
                  product.brand!,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
              if (product.quantity != null) ...[
                const SizedBox(height: 4),
                Text(
                  product.quantity!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Séparateur de section, avec les 24 px imposés de part et d'autre.
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 49,
      thickness: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
