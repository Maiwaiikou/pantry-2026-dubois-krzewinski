
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantry/data/stock_scope.dart';

import 'package:pantry/ui/add_product_page.dart';
import 'package:pantry/ui/product_detail_page.dart';
import 'package:pantry/ui/stock_page.dart';

GoRouter createRouter(){
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(
          name: 'stock',
          child: StockPage()
        ),
        routes: [
          GoRoute(
            path: 'product/:barcode',
            pageBuilder: ((context, state) {
              final barcode = state.pathParameters['barcode'];
              final products = StockScope.of(context).products;
              final matches = products.where((p)=>p.barcode == barcode);
              return MaterialPage(
                name: 'product',
                child: matches.isEmpty ?
                        UnknownProductPage(barcode: barcode!)
                        : ProductDetailPage(product: matches.first)
              );
            }
            )
          ),
          GoRoute(
            path: 'add',
            pageBuilder:(context, state) => MaterialPage(
              name: 'add',
              child: AddProductPage()
            ),
          )
        ]
      )
    ], 
    errorBuilder: (context, state) => 
      UnknownRoutePage(location: state.uri.path)
  );
}

class UnknownProductPage extends StatelessWidget {
  const UnknownProductPage({required this.barcode, super.key});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Fiche produit')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.help_outline,
                size: 48,
                color : theme.colorScheme.onSurfaceVariant, 
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun produit du stock ne porte le code-barre $barcode',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: ()=> context.go('/'),
                child: const Text('Retour au stock')
              )
            ],
          )
        )
      )
    );
  }
}

class UnknownRoutePage extends StatelessWidget{
  const UnknownRoutePage({required this.location, super.key});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page introuvable')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aucun écran ne correspond à $location',
                textAlign: TextAlign.center,
                style : Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Retour au stock'),
              )
            ]
          )
        )
      )
    );
  }
}