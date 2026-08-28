# Séance 3 · TP : recherche, navigation, thème

Deux exercices, un par créneau de TP. À l'issue de la séance, l'application comporte une liste de
stock filtrable, une navigation par URL, un thème complet avec mode sombre, et un stock propagé à
tout l'arbre par un `InheritedWidget` écrit à la main.

| | Exercice | Créneau |
|---|---|---|
| 1 | Recherche, liste, navigation, retrait par balayage | TP 1, 60 min |
| 2 | Thème, mode sombre, transition `Hero`, propagation du stock | TP 2, 60 min |

L'exercice 1 est la priorité du premier créneau. L'exercice 2 suppose la liste et les routes en
place, sauf son étape 1, le thème. Si le temps manque, la priorité en séance est le thème, puis la
propagation du stock ; la transition `Hero` et les deux exercices de « Pour aller plus loin »
peuvent se terminer en dehors de la séance.

## Démarrer

```bash
git switch session-03-start
flutter pub get
flutter run -d chrome
```

Le `pubspec.yaml` est celui de la séance 2. L'exercice 1 y ajoute `go_router`.

Travailler sur une branche personnelle :

```bash
git switch -c tp03-<votrenom>
```

## Point de départ

La branche part du corrigé de la séance 2. Cinq fichiers en diffèrent :

| Fichier | État |
|---|---|
| `lib/data/mock_products.dart` | **dix-huit produits réels**, dont six avec date de péremption |
| `lib/main.dart` | le stock et ses deux opérations, `addProduct` et `removeProduct` |
| `lib/ui/stock_page.dart` | le contrat de l'écran de liste : trois paramètres, et rien d'autre |
| `lib/ui/product_detail_page.dart` | la fiche de la séance 2, sans le sélecteur de produit |
| `lib/ui/add_product_page.dart` | le formulaire de la séance 2, inchangé |

Le stock vit dans `_PantryAppState` : trois écrans en dépendent, il ne peut donc pas vivre dans
l'un d'eux. Le faire descendre jusqu'aux écrans, par les paramètres des routes, est le travail de
l'exercice 1 ; l'exercice 2 supprime ces paramètres.

---

## Exercice 1 · recherche, liste et navigation

### Paquets à ajouter

```bash
flutter pub add go_router:18.0.0
```

La commande inscrit le paquet dans `pubspec.yaml`, résout les paquets dont il dépend à son
tour, et met à jour `pubspec.lock`. La version est imposée : le corrigé et les séances suivantes
sont écrits pour elle. Les deux fichiers se committent avec le reste.

### Les trois routes

Ces chemins sont imposés : le débrief compare les rendus, et la séance 10 rouvrira ces mêmes URL
en liens profonds.

| Chemin | Écran | Atteint par |
|---|---|---|
| `/` | `StockPage` | démarrage |
| `/product/:barcode` | `ProductDetailPage` | appui sur une ligne de la liste, par `context.go` |
| `/add` | `AddProductPage` | bouton d'action de `StockPage`, par `context.push` |

`/add` **renvoie le produit saisi** à l'écran appelant, qui le transmet à `addProduct`. Le callback
`onSubmitted` du formulaire disparaît : c'est la route qui porte la valeur de retour.

### Travail attendu

1. Remplacer `MaterialApp` par `MaterialApp.router` et déclarer le `GoRouter` correspondant.
2. Construire `StockPage` : champ de recherche, liste filtrée, ligne de produit, retrait par
   balayage, bouton d'ajout.
3. La recherche filtre sur le **nom** et sur la **marque**, sans distinction de casse. Un champ
   vide affiche tout le stock.
4. Le paramètre `:barcode` sert à retrouver le produit dans le stock.

### Critères d'acceptation

- [ ] La liste utilise `ListView.builder`, jamais `ListView(children: [...])`
- [ ] Chaque ligne affiche au minimum le nom, la marque quand elle existe, et la date de
      péremption quand elle existe
- [ ] Un nom long tient sur une ligne au maximum, avec troncature `…`, à vérifier sur les biscuits
      Nutella
- [ ] La recherche « bjorg » renvoie deux produits, « pain » deux produits, « zzz » aucun
- [ ] Recherche sans résultat : un texte l'indique, la liste n'est pas simplement vide
- [ ] Le balayage d'une ligne retire le produit du stock, et une `SnackBar` le confirme
- [ ] Après un retrait, la liste ne conserve aucune ligne fantôme et aucune exception n'apparaît
      dans la console
- [ ] Ouvrir une fiche change l'URL en `/#/product/<code-barres>`, et le bouton **Retour du
      navigateur** revient à la liste ; `/add`, empilée par `push`, garde l'URL de la liste
- [ ] `/#/product/3017620422003` collé dans la barre d'adresse ouvre directement la fiche Nutella
- [ ] `/#/product/0000000000000` affiche un état « produit introuvable », pas une exception
- [ ] Une URL sans route correspondante affiche un écran, jamais l'écran rouge de debug
- [ ] Un produit ajouté par `/add` apparaît dans la liste, et le formulaire n'est plus appelé par
      un callback
- [ ] `flutter analyze` ne signale rien

### Points d'attention

**`Dismissible` exige une clé.** L'enfant disparaît de l'arbre avant que la liste ne soit
reconstruite : sans identité stable, Flutter ne sait pas quelle ligne a été retirée. Le message
d'erreur se lit en entier.

**Le paramètre de route est une chaîne.** Quand la route correspond,
`state.pathParameters['barcode']` est toujours une chaîne non vide : `/product/` seul ne correspond
pas et part dans `errorBuilder`. Le type `String?` vient de l'opérateur `[]` d'une `Map`, et `!` y
est sûr. La chaîne peut en revanche désigner un produit absent du stock : c'est le cas à traiter.

**Déclarer les routes avec `pageBuilder` et `MaterialPage`, pas avec `builder`.** Ce point n'est pas
l'objet de l'exercice. Avec `builder`, `go_router` choisit
le type de page en cherchant un `MaterialApp` au-dessus de lui ; cette détection échoue avec la
version de Flutter du cours, et chaque route devient une page **sans transition**. Aucune erreur
n'est levée : les écrans se remplacent d'un coup, et les `Hero` de l'exercice 2 ne volent pas.

```dart
GoRoute(
  path: '/',
  pageBuilder: (context, state) => MaterialPage(child: StockPage(…)),
)
```

**L'URL du web comporte un `#`.** Flutter sert l'application depuis une seule page ; la partie
après le `#` n'est pas envoyée au serveur, ce qui évite toute configuration. `usePathUrlStrategy()`
retire le `#`, mais exige alors que le serveur renvoie `index.html` pour toute URL inconnue. Le
sujet est repris en séance 9.

---

## Exercice 2 · thème, mode sombre et propagation du stock

### Le thème

Sortir le thème de `main.dart` vers `lib/theme/`, et le construire en deux exemplaires, clair et
sombre, à partir de la même graine `Color(0xFF3F7D58)`.

Les valeurs suivantes ne relèvent pas de `ColorScheme` : elles constituent le jeu de tokens de
l'application, à porter par une `ThemeExtension`.

| Token | Mode clair | Mode sombre | Usage |
|---|---|---|---|
| `nutriA` … `nutriE` | `#038141` `#85BB2F` `#FECB02` `#EE8100` `#E63E11` | identiques | échelle Nutri-Score, normalisée |
| `expirySoon` | `#B25E00` | `#FFB77A` | péremption dans 7 jours ou moins |
| `expiryPassed` | `#B3261E` | `#FF9C94` | péremption dépassée |
| `sectionGap` | `24` | `24` | espacement entre deux sections de la fiche |

Les cinq teintes du Nutri-Score sont normalisées par le dispositif : elles ne changent pas avec le
mode. Les deux couleurs de péremption, si : un rouge sombre sur fond sombre n'est pas lisible.

### Travail attendu

1. `lib/theme/` : un `ThemeData` clair, un sombre, et une `ThemeExtension` portant les tokens.
2. `NutriScoreScale` lit ses couleurs dans la `ThemeExtension` au lieu de sa constante privée.
3. La date de péremption de la liste prend la couleur `expirySoon` ou `expiryPassed` selon le cas.
4. Un `InheritedWidget` **écrit à la main** expose le stock à tout l'arbre. Les trois paramètres
   que la table de routage faisait descendre disparaissent : chaque écran lit le stock dans son
   contexte.
5. Une transition `Hero` relie la vignette de la liste à celle de la fiche.

### Critères d'acceptation

- [ ] `main.dart` ne contient plus aucune valeur de couleur
- [ ] Le basculement du mode sombre du système change l'apparence sans redémarrage. Dans Chrome,
      DevTools → *Rendering* → `prefers-color-scheme`
- [ ] Aucune couleur en dur dans les widgets : tout vient de `colorScheme` ou de la
      `ThemeExtension`
- [ ] La `ThemeExtension` implémente `copyWith` et `lerp` ; le mode ne change pas brutalement
- [ ] Le Skyr, périmé depuis dix jours, s'affiche dans la couleur `expiryPassed`
- [ ] Les biscuits Nutella, qui périment dans trois jours, s'affichent dans la couleur
      `expirySoon`
- [ ] **La table de routage ne reçoit plus le stock.** Les écrans le lisent par un `of(context)`
- [ ] L'`InheritedWidget` qui porte le stock **n'est pas public** : le point d'entrée est une
      méthode statique, comme `Theme.of`
- [ ] Un ajout et un retrait mettent la liste à jour, et la fiche reste cohérente après un retour
- [ ] `updateShouldNotify` est implémenté, et sa condition est justifiable. Remplacer la
      construction d'une nouvelle liste par une mutation de la liste existante doit être expliqué :
      qu'observe alors la comparaison ?
- [ ] Un `of(context)` sans portée au-dessus de lui échoue de façon explicite, et non en silence.
      Retirer temporairement de `main.dart` le widget qui porte la portée et relancer : un écran
      d'erreur s'affiche, et la console donne un message qui nomme la portée manquante
- [ ] La transition `Hero` fonctionne dans les deux sens, retour du navigateur compris
- [ ] `flutter analyze` ne signale rien

### Points d'attention

**Un `InheritedWidget` ne porte pas d'état mutable.** Il est immuable, comme tout widget. Le
`State` qui détient la valeur est au-dessus de lui, et le reconstruit à chaque changement. Trois
classes coopèrent donc, et le framework donne le modèle exact : `ThemeData` porte la donnée,
`Theme.of` est le point d'entrée, `_InheritedTheme` propage et reste privé.

**L'ordre des enveloppes compte.** Les écrans sont construits par la table de routage : la portée
doit se trouver au-dessus de `MaterialApp.router`, sinon aucun écran ne la voit.

**`updateShouldNotify` décide des reconstructions.** Renvoyer toujours `true` fonctionne mais
reconstruit tous les dépendants à chaque build du parent. Renvoyer toujours `false` ne reconstruit
jamais rien : l'interface se figera sans lever d'erreur.

**Comparer deux listes n'est pas comparer deux références.** Une opération qui construit une
nouvelle liste rend le changement observable ; une opération qui modifie la liste existante laisse
les deux références identiques. Le choix se fait en écrivant `addProduct` et `removeProduct`, pas en
écrivant `updateShouldNotify`.

**`of(context)` inscrit une dépendance.** `dependOnInheritedWidgetOfExactType` inscrit l'`Element`
appelant comme dépendant, et l'inscription porte sur la **liste entière**. Un écran qui n'affiche
qu'un compteur se reconstruira donc à chaque changement de stock : c'est la limite que la séance 5
traite.

**Deux `Hero` de même `tag` dans le même écran lèvent une exception.** Le tag doit être unique par
écran, ce qui fait du code-barres un bon candidat.

---

## Pour aller plus loin

Jauge Nutri-Score en `CustomPainter` : un arc gradué de A à E, avec l'aiguille sur la note du
produit, dessiné dans un `SizedBox` de 220 × 110 de la fiche. Les couleurs viennent de la
`ThemeExtension`. Aucun paquet.

`CustomPainter` demande deux méthodes : `paint(Canvas, Size)` et `shouldRepaint`. Le repère a son
origine en haut à gauche, et les angles sont en radians.

Choix du mode dans l'application : un menu dans la barre de la liste, à trois entrées, système,
clair et sombre. `MaterialApp.router` reçoit le choix par son paramètre `themeMode`, qui vaut
`ThemeMode.system` par défaut. Le choix est un état de l'application, lu par `MaterialApp.router`
et modifié depuis un écran que construit la table de routage : il se place comme le stock.

Le passage d'un thème à l'autre est un fondu de 200 ms. Un `lerp` de la `ThemeExtension` qui
renvoie `this` s'y voit : les couleurs de péremption restent fixes, puis changent d'un coup.

## Fin de séance

Committer le travail sur sa branche avant la séance suivante : `git switch` refuse de changer de
branche, ou emporte les modifications en cours, tant qu'elles ne sont pas committées.

```bash
git add -A
git commit -m "TP 3"
```

Le corrigé est publié sur `session-03-solution` à l'issue de la séance.
