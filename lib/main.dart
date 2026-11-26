import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantry/data/stock_scope.dart';
import 'package:pantry/router.dart';
import 'package:pantry/theme/pantry_theme.dart';
import 'package:pantry/theme/theme_mode_scope.dart';

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
  late final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return StockScope(
      child: ThemeModeScope(
        child: Builder(
          builder: (context) => MaterialApp.router(
            title: 'pantry',
            debugShowCheckedModeBanner: false,
            theme: PantryTheme.light,
            darkTheme: PantryTheme.dark,
            themeMode: ThemeModeScope.of(context).value,
            routerConfig: _router,
          )
        )
      )
    );
  }
}
