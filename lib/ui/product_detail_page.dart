import 'package:flutter/material.dart';

import 'package:pantry/models/product.dart';
import 'package:pantry/ui/widgets/detail_section.dart';
import 'package:pantry/ui/widgets/nutri_score_scale.dart';
import 'package:pantry/ui/widgets/product_image_placeholder.dart';

/// Écran « fiche produit », **à construire, exercice 1 du TP 2**.
///
/// Reproduire `design/fiche-produit.svg`. La maquette fixe les espacements,
/// les tailles et les rôles de couleur ; ces valeurs sont normatives.
///
/// Le sélecteur de produit de l'AppBar est fourni : il permet de parcourir le
/// jeu mocké, dont plusieurs entrées sont volontairement incomplètes. La fiche
/// doit rester correcte pour **tous** les produits de la liste, et non pour le
/// seul premier.
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
          // Fourni : permet de passer d'un produit mocké à l'autre pour
          // vérifier les cas incomplets.
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
      body: _ToDo(product: product, onProductRequested: onProductRequested, availableProducts: availableProducts),
    );
  }
}

/// À SUPPRIMER une fois la fiche construite.
class _ToDo extends StatelessWidget {
  const _ToDo({required this.product,
    required this.onProductRequested,
    required this.availableProducts,});

  final Product product;
  final List<Product> availableProducts;
  final ValueChanged<Product> onProductRequested;

  @override
  Widget build(BuildContext context) {
    return 
      ListView(
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
                ?const MissingValue('Aucune catégorie renseignée')
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final category in product.categories)
                        Chip(label: Text(category)),
                    ]
                )  
            ),
            const _SectionDivider(),
            DetailSection(
              title: 'Code-barres',
              child: Text(product.barcode),
            ),
            const SizedBox(height: 24),
            DetailSection(
              title: 'Péremption',
              child: product.expiresOn == null
                ? const MissingValue('Non renseignée')
                : Text(_formatDate(product.expiresOn!)),
            ),
            const SizedBox(height: 24),
          ]
        );

        
  }
}
String _formatDate(DateTime date) {
  final d = date.day.toString().padLeft( 2, '0');
  final m = date.month.toString().padLeft( 2, '0');
  return '$d/$m/${date.year}';   
}

class _Header extends StatelessWidget{
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(
                product.displayName,
                style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if(product.brand != null) ...[
                const SizedBox(height: 4),
                Text(
                  product.brand!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if(product.quantity != null) ...[
                const SizedBox(height: 4),
                Text(
                  product.quantity!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ]
            ]
          )
        )
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget{
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