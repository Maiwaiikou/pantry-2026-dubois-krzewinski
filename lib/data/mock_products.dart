import 'package:pantry/models/product.dart';

/// Date située [days] jours après le lancement de l'application, ou avant si
/// le nombre est négatif.
///
/// Les dates de péremption sont relatives au jour où l'application tourne :
/// le Skyr est toujours périmé, les biscuits périment toujours dans trois
/// jours, quelle que soit la date de la séance.
DateTime _inDays(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
}

/// Jeu de données des séances 2 et 3.
///
/// Les dix-huit produits existent dans Open Food Facts. Codes-barres, noms,
/// marques, contenances et Nutri-Scores viennent de la base. Les catégories
/// sont une liste courte, écrite à la main depuis les catégories réelles,
/// souvent au nombre d'une dizaine par produit.
///
/// Certains champs sont absents, défaut fréquent des fiches de la base :
///
///  - `3017620422003` n'a pas de contenance ;
///  - `6111180000231` n'a ni marque, ni Nutri-Score, ni catégorie
///    consommateur, ses seuls tags étant techniques ;
///  - `6111242100985` n'a pas de nom : la base n'en porte qu'un en arabe, et
///    le champ que lit l'application est vide ;
///  - `8000500310427` porte un nom long, qui éprouve la mise en page du titre.
///
/// Dix-huit produits et non six : une liste filtrable a besoin de matière, et
/// `ListView.builder` n'a d'intérêt visible qu'au-delà de l'écran.
///
/// Six produits portent une date de péremption, dont une déjà dépassée. Ces
/// dates sont écrites en dur, ce qui explique que la liste soit `final` et non
/// plus `const` comme en séance 2 : `DateTime` n'est pas un constructeur
/// `const`.
///
/// La séance 4 remplace cette liste par des appels réseau. La forme des
/// données reste identique.
final List<Product> mockProducts = [
  const Product(
    barcode: '3017620422003',
    name: 'Nutella',
    brand: 'Ferrero',
    // Contenance absente : la fiche doit s'en passer.
    nutriScore: 'e',
    categories: ['Petit-déjeuners', 'Pâtes à tartiner'],
  ),
  const Product(
    barcode: '3046920022651',
    name: 'Noir Intense',
    brand: 'Lindt',
    quantity: '100 g',
    nutriScore: 'e',
    categories: ['Snacks sucrés', 'Chocolats'],
  ),
  Product(
    barcode: '3229820129488',
    name: 'Muesli raisin, figue, datte, abricot',
    brand: 'Bjorg',
    quantity: '375 g',
    nutriScore: 'a',
    categories: ['Petit-déjeuners', 'Céréales'],
    expiresOn: _inDays(45),
  ),
  const Product(
    barcode: '3168930010265',
    name: 'Cruesly mélange de noix',
    brand: 'Quaker',
    quantity: '450 g',
    nutriScore: 'b',
    categories: ['Petit-déjeuners', 'Céréales'],
  ),
  // Nom long, sur deux lignes au maximum dans la fiche comme dans la liste.
  Product(
    barcode: '8000500310427',
    name: 'Biscuits Nutella noisettes et cacao x22',
    brand: 'Nutella',
    quantity: '304 g',
    nutriScore: 'e',
    categories: ['Snacks sucrés', 'Biscuits et gâteaux'],
    expiresOn: _inDays(3),
  ),
  // Ni marque, ni Nutri-Score, ni catégorie.
  const Product(
    barcode: '6111180000231',
    name: 'Levure pâtisserie',
    quantity: '80 g',
  ),
  // Sans nom : le libellé de repli du modèle prend le relais.
  const Product(
    barcode: '6111242100985',
    brand: 'Jaouda',
    quantity: '80 g',
    nutriScore: 'a',
    categories: ['Produits laitiers', 'Fromages blancs'],
  ),
  const Product(
    barcode: '3760049798609',
    name: 'Pain de mie grandes tranches seigle et graines',
    brand: 'La Boulangère',
    quantity: '500 g',
    nutriScore: 'a',
    categories: ['Pains', 'Pains de mie'],
  ),
  const Product(
    barcode: '3228857002344',
    name: 'Pain de mie American Sandwich complet sans sucres ajoutés',
    brand: 'Harrys',
    quantity: '600 g',
    nutriScore: 'b',
    categories: ['Pains', 'Pains de mie'],
  ),
  const Product(
    barcode: '7311070032611',
    name: 'Krisprolls complets',
    brand: 'Krisprolls',
    quantity: '425 g',
    nutriScore: 'a',
    categories: ['Biscottes et pains grillés'],
  ),
  // Péremption dépassée : la couleur d'urgence la plus forte.
  Product(
    barcode: '3329770077003',
    name: 'Skyr nature 0 %',
    brand: 'Yoplait',
    quantity: '850 g',
    nutriScore: 'a',
    categories: ['Produits laitiers', 'Yaourts'],
    expiresOn: _inDays(-10),
  ),
  const Product(
    barcode: '3229820100234',
    name: 'Fourrés chocolat noir',
    brand: 'Bjorg',
    quantity: '225 g',
    nutriScore: 'd',
    categories: ['Snacks sucrés', 'Biscuits sandwich'],
  ),
  const Product(
    barcode: '3760020507350',
    name: 'Pur beurre de cacahuète',
    brand: 'Jardin Bio étic',
    quantity: '350 g',
    nutriScore: 'b',
    categories: ['Produits à tartiner', 'Beurres de fruits à coque'],
  ),
  const Product(
    barcode: '3608580065340',
    name: 'Pâte à tartiner noisettes et cacao',
    brand: 'Bonne Maman',
    quantity: '360 g',
    nutriScore: 'e',
    categories: ['Petit-déjeuners', 'Pâtes à tartiner'],
  ),
  Product(
    barcode: '8076809513753',
    name: 'Pesto alla Genovese',
    brand: 'Barilla',
    quantity: '190 g',
    nutriScore: 'e',
    categories: ['Sauces', 'Pestos'],
    expiresOn: _inDays(140),
  ),
  Product(
    barcode: '3168930163480',
    name: "Gazpacho l'original",
    brand: 'Alvalle',
    quantity: '1 L',
    nutriScore: 'b',
    categories: ['Soupes', 'Gaspachos'],
    expiresOn: _inDays(60),
  ),
  Product(
    barcode: '3155250358788',
    name: 'Margarine bio doux tartine et cuisson',
    brand: 'Primevère',
    quantity: '250 g',
    nutriScore: 'c',
    categories: ['Matières grasses', 'Margarines'],
    expiresOn: _inDays(240),
  ),
  const Product(
    barcode: '5449000054227',
    name: 'Coca-Cola Original Taste',
    brand: 'Coca-Cola',
    quantity: '1 L',
    nutriScore: 'e',
    categories: ['Boissons', 'Sodas'],
  ),
];
