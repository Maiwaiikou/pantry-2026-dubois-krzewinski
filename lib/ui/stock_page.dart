import 'package:flutter/material.dart';

import 'package:pantry/models/product.dart';

/// Écran « mon stock » : recherche, liste, retrait par balayage.
///
/// Seul le contrat est fourni : `products` est le stock complet, non filtré,
/// `onProductAdded` reçoit le produit que renvoie la route `/add`, et
/// `onProductRemoved` le code-barres du produit retiré. Le champ de recherche,
/// le filtrage, la liste, la ligne de produit et la navigation font partie de
/// l'exercice.
class StockPage extends StatefulWidget {
  const StockPage({
    required this.products,
    required this.onProductAdded,
    required this.onProductRemoved,
    super.key,
  });

  /// Stock complet, dans l'ordre d'ajout. Le filtrage n'est pas fait ici.
  final List<Product> products;

  /// Appelé avec le produit renvoyé par la route `/add`.
  final ValueChanged<Product> onProductAdded;

  /// Appelé avec le code-barres du produit retiré du stock.
  final ValueChanged<String> onProductRemoved;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon stock')),
      body: const Center(
        child: Text('À construire : exercice 1 de TP.md'),
      ),
    );
  }
}
