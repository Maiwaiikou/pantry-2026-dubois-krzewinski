import 'package:flutter/material.dart';

import 'package:pantry/models/product.dart';

/// Écran « ajouter un produit », **à construire, exercice 2 du TP 2**.
///
/// L'énoncé complet figure dans `TP.md`.
///
/// Seul le contrat avec le reste de l'application est fourni : `onSubmitted`
/// reçoit le produit saisi, une fois le formulaire valide. Tout le reste,
/// structure de l'écran, champs, validation, libération des ressources, fait
/// partie de l'exercice.
class AddProductPage extends StatefulWidget {
  const AddProductPage({required this.onSubmitted, super.key});

  /// Appelé avec le produit saisi quand le formulaire est valide.
  final ValueChanged<Product> onSubmitted;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  final _formKey = GlobalKey<FormState>();
  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  DateTime? _expiresOn;

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String? _validateBarcode(String? value){
    final text = value?.trim() ?? '';
    if(text.isEmpty){
      return 'Le code-barres est obligatoire';
    }
    if(!RegExp(r'^\d+$').hasMatch(text)){
      return 'Le code-barres ne contient que des chiffres';
    }
    if(text.length != 13){
      return '13 chiffres attendus, ${text.length} saisis';
    }
    return null;
  }

  String? _validateName(String? value){
    final text = value?.trim() ?? '';
    if(text.isEmpty){
      return 'Le nom est obligatoire';
    }
    if(text.length <2){
      return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
  }

  String? _validateExpiry(DateTime? value){
    if(value == null){
      return 'La date de péremption est obligatoire';
    }
    final today = DateUtils.dateOnly(DateTime.now());
    if(!DateUtils.dateOnly(value).isAfter(today)){
      return 'La date de péremption doit être dans le futur';
    }
    return null;
  }

  Future<void> _pickDate(FormFieldState<DateTime?> field) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context, 
      initialDate: field.value ?? today.add(const Duration(days: 7)),
      firstDate: today.add(const Duration(days: 1)),
      lastDate: DateTime(today.year +10), 
      helpText: 'Date de péremption',
    );

    if(picked ==null || !mounted){
      return;
    }

    field
      ..didChange(picked)
      ..validate();
    setState(() {
      _expiresOn = picked;
    });
  }

  void _submit(){
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final quantity = _quantityController.text.trim();
    widget.onSubmitted(
      Product(
        barcode: _barcodeController.text.trim(),
        name: _nameController.text.trim(),
        quantity: quantity.isEmpty ? null : quantity,
        expiresOn: _expiresOn,
      )
    );

    formState.reset();
    _barcodeController.clear();
    _nameController.clear();
    _quantityController.clear();
    setState(() {
      _expiresOn = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un produit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: 'Code-barres',
                helperText: '13 chiffres',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: _validateBarcode,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du produit',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: _validateName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantité',
                helperText: 'Facultatif, « 400 g », « 1 L »…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FormField<DateTime>(
              validator: _validateExpiry,
              builder: (field) => InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date de péremption',
                  errorText: field.errorText,
                  border: const OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: () => _pickDate(field),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          field.value == null
                              ? 'Choisir une date'
                              : _formatDate(field.value!),
                          style: field.value == null
                              ? TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurfaceVariant,
                                )
                              : null,
                        ),
                      ),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: const Text('Ajouter au stock'),
            ),
          ]
        )
      )
    );
  }
}
String _formatDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$d/$m/${date.year}';
}