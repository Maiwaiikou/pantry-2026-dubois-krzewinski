import 'package:flutter/material.dart';

import 'package:pantry/models/product.dart';
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
            Column(
              children: [
                Row(
                  children: [
                    ProductImagePlaceholder(initial: product.initial),
                    const SizedBox(width: 16),
                    Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.displayName, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis),
                        Text(product.brand != null ? product.brand! : '', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                        Text(product.quantity != null ? product.quantity! : '', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 49, thickness: 1),

              Text("NUTRI-SCORE", style: Theme.of(context).textTheme.titleSmall)

              
            ],
          )],
        );
    /*return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProductImagePlaceholder(initial: product.initial),
            const SizedBox(height: 16),
            Text(
              product.displayName,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'À construire : reproduire design/fiche-produit.svg.\n\n'
              'Remplacer ce widget par la fiche complète, puis vérifier le '
              'rendu sur les six produits accessibles par le menu ↔ en haut à '
              'droite : plusieurs sont incomplets.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );*/
  }
}
