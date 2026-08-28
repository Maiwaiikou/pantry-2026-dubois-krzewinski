import 'package:flutter/material.dart';

import 'package:pantry/data/mock_products.dart';
import 'package:pantry/models/product.dart';
import 'package:pantry/ui/stock_page.dart';

void main() => runApp(const PantryApp());

/// Racine de l'application, et dépositaire du stock.
///
/// Le stock est porté ici parce que trois écrans en dépendent : la liste
/// l'affiche, la fiche en lit un élément, le formulaire y ajoute. Un `State`
/// placé plus bas ne serait pas visible des deux autres écrans.
///
/// `addProduct` et `removeProduct` sont le **contrat** de la séance : la liste
/// reçoit le stock et `removeProduct`, le formulaire produit un `Product` qui
/// aboutit à `addProduct`. La façon de les faire descendre jusqu'aux écrans
/// fait partie du TP.
///
/// Aucune donnée n'est persistée : le stock repart des produits mockés à
/// chaque rechargement. La persistance est le sujet de la séance 7.
class PantryApp extends StatefulWidget {
  const PantryApp({super.key});

  @override
  State<PantryApp> createState() => _PantryAppState();
}

class _PantryAppState extends State<PantryApp> {
  late List<Product> _products = List.of(mockProducts);

  /// Ajoute un produit au stock, ou remplace celui qui porte le même
  /// code-barres.
  ///
  /// Le code-barres est l'identité d'un produit : deux exemplaires du même
  /// article ne forment qu'une entrée. Cette règle est ce qui autorise
  /// `ValueKey(product.barcode)` dans la liste.
  void addProduct(Product product) {
    setState(() {
      final index = _products.indexWhere((p) => p.barcode == product.barcode);
      _products = index == -1
          ? [..._products, product]
          : [
              ..._products.sublist(0, index),
              product,
              ..._products.sublist(index + 1),
            ];
    });
  }

  void removeProduct(String barcode) {
    setState(() {
      _products = _products.where((p) => p.barcode != barcode).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO(tp-03): remplacer `MaterialApp` par `MaterialApp.router` et
    // déclarer les trois routes de l'énoncé. Le thème part dans `lib/theme/`
    // à l'exercice 2.
    return MaterialApp(
      title: 'Pantry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F7D58)),
        useMaterial3: true,
      ),
      home: StockPage(
        products: _products,
        onProductAdded: addProduct,
        onProductRemoved: removeProduct,
      ),
    );
  }
}
