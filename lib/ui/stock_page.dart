import 'package:flutter/material.dart';

import 'package:pantry/models/product.dart';
import 'package:pantry/ui/product_detail_page.dart';

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
  String _query = '';

  List<Product> get _filteredProducts {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.products;
    }
    return widget.products.where((product) {
      final name = product.name?.toLowerCase() ?? '';
      final brand = product.brand?.toLowerCase() ?? '';
      return name.contains(query) || brand.contains(query);
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon stock')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder:(context, index) {
                  final product = _filteredProducts[index];


                  return Dismissible(
                    key: ValueKey(product.barcode),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      widget.onProductRemoved(product.barcode);
                    },
                    child: ProductRow(
                      product: product,
                      onProductRemoved: widget.onProductRemoved,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                    ),
                  );
              }),
            ),
        ],
      ),
      );
  }
}

class ProductRow extends StatelessWidget {
  const ProductRow({
    super.key,
    required this.product,
    required this.onProductRemoved,
    required this.onTap,
  });

  final Product product;
  final ValueChanged<String> onProductRemoved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: product.name != null ? Text(product.name!) : const Text('Nom non disponible'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.brand != null)
            Text('Marque : ${product.brand}'),
          
          if (product.expiresOn != null)
            Text('Date de péremption : ${product.expiresOn}'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onProductRemoved(product.barcode),
      ),
      onTap: onTap,
    );
  }
}
