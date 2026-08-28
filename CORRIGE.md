# Séance 2 · corrigé

Ce document commente les décisions du corrigé. Il ne reprend pas l'énoncé, qui reste dans `TP.md`.

## Fiche produit

**`ListView` et non `Column`.** Une `Column` reçoit une contrainte de hauteur bornée et déborde dès
que la fenêtre est basse, ce que signale le bandeau rayé. Le `ListView` résout le problème et rend
le défilement gratuit.

**`Expanded` autour du bloc texte de l'en-tête.** Sans lui, la `Column` intérieure reçoit une
largeur non bornée : `maxLines` et `TextOverflow.ellipsis` n'ont alors aucun effet et le nom long
déborde. C'est l'illustration directe de la règle « les contraintes descendent, les tailles
remontent ».

**Les champs absents ne produisent aucun widget.** L'usage de `if (…) ...[ ]` dans une liste
d'enfants supprime la ligne au lieu d'afficher un vide ou un tiret. Trois traitements coexistent
selon le cas :

| Cas | Traitement |
|---|---|
| marque, quantité | la ligne disparaît |
| Nutri-Score, catégories, date | texte de repli, en italique atténué |
| nom | valeur de repli fournie par le modèle (`displayName`) |

**`DetailSection` et `MissingValue` sont factorisés.** La maquette impose les mêmes valeurs à
chaque section ; les dupliquer garantit qu'elles divergeront.

**Les cinq teintes du Nutri-Score sont normalisées par le dispositif**, et c'est l'exception
admise. Sur une case sélectionnée, la couleur du texte, `Colors.white` ou un gris sombre, se
choisit d'après la luminosité du fond via `ThemeData.estimateBrightnessForColor`, ce fond étant
lui-même une teinte imposée. Le gris des lettres non sélectionnées, `Color(0xFF2E332E)`, est en
revanche une couleur en dur que le critère interdit : deux couleurs restent en dur dans l'échelle,
et la séance 3 montre ce que le mode sombre en fait.

**`AnimatedContainer` pour la case sélectionnée.** C'était le premier bonus de l'énoncé, et il coûte
un mot-clé : la case passe de 36 × 40 à 44 × 48 en 200 ms au changement de produit. Les animations
implicites sont le sujet de la séance 3.

## Formulaire

L'énoncé ne fournissait que `onSubmitted` et un `Scaffold` vide. Le choix de `Form`, des
contrôleurs et de leur libération faisait partie de l'exercice ; des variantes sont donc attendues.

**Le sélecteur de date est un `FormField<DateTime>`.** Les deux solutions proposées dans l'énoncé
sont acceptées. Le corrigé retient `FormField<DateTime>` : la date entre alors dans le cycle
normal du formulaire. `validate()` la prend en compte, l'erreur s'affiche au même endroit et dans
le même style que les autres, la bordure passe au rouge, et `reset()` la remet à zéro avec le
reste. Le contrôle manuel dans `_submit` oblige à réimplémenter chacun de ces quatre comportements.

`field.didChange(picked)` (et non un simple `setState`) enregistre la valeur dans le champ et
notifie le `Form` ; `field.validate()` efface aussitôt le message d'une soumission précédente. Le
champ n'a pas d'`initialValue` : `reset()` le ramène à vide, en accord avec `_expiresOn`, remis à
`null` dans `_submit`. Le test de `mounted` après `showDatePicker` couvre une page fermée pendant
le choix.

**La comparaison de dates passe par `DateUtils.dateOnly`.** Comparer deux `DateTime` compare des
instants : une date choisie pour aujourd'hui serait acceptée le matin et refusée le soir, ou
l'inverse. Ramener les deux valeurs à minuit supprime la dépendance à l'heure.

**Le sélecteur interdit déjà le passé** via `firstDate`, mais le validateur reste nécessaire : il
couvre le cas où aucune date n'a été choisie, que `showDatePicker` ne peut pas empêcher.

**Les messages d'erreur comptent.** « 13 chiffres attendus, 8 saisis » indique la correction ;
« invalide » oblige l'utilisateur à deviner.

## Points à relever au débrief

- **Le formulaire revient-il à vide après un ajout ?** Contrôleurs compris : l'oubli ne se voit
  qu'au deuxième ajout.
- **Les contrôleurs sont-ils libérés ?** L'oubli ne produit ni exception, ni remarque de
  `flutter analyze`, ni symptôme à l'écran : le `dispose` se vérifie à la lecture. Ici, le
  formulaire vit dans l'`IndexedStack` de `HomeShell` : son `State` n'est jamais démonté, et
  `dispose` n'est jamais appelé. Dès la séance 3, `/add` devient une route empilée, recréée à
  chaque passage. Qui crée un contrôleur le libère, quel que soit le conteneur du moment.
- **Que reste-t-il après un rechargement ?** Rien : aucune donnée n'est persistée. La séance 7 y
  revient.
- **Le menu de l'AppBar est-il annoncé ?** Le `PopupMenuButton` n'est pas exposé tel quel à l'arbre
  d'accessibilité ; la séance 9 y revient.
