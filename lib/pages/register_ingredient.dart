import 'package:flutter/material.dart';
import 'package:mobile/models/ingredient.dart';
import 'package:mobile/services/ingredient_service.dart';

class RegisterIngredient extends StatefulWidget {
  final Ingredient? ingredient;

  const RegisterIngredient({super.key, this.ingredient});

  //@override
  // State<RegisterIngredient> createState() => _RegisterIngredientState();
  //const RegisterIngredient({super.key, });

  @override
  State<RegisterIngredient> createState() => _RegisterIngredientState();
}

class _RegisterIngredientState extends State<RegisterIngredient> {
  IngredientService ingredientService = IngredientService();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _unitController;
  late TextEditingController _priceController;

  void _register() async {
    print(_nameController.text);
    print(_quantityController.text);
    print(_unitController.text);
    print(_priceController.text);

    if (_nameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _unitController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return;
    }

    try {
      await ingredientService.registerIngredient(
          _nameController.text,
          double.parse(_quantityController.text),
          _unitController.text,
          double.parse(_priceController.text));
      Navigator.pop(context);
      return;
    } catch (e) {
      print(e);
    }
  }

  void _update() async {
    if (_nameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _unitController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return;
    }

    try {
      await ingredientService.updateIngredient(
          widget.ingredient!.id,
          _nameController.text,
          double.parse(_quantityController.text),
          _unitController.text,
          double.parse(_priceController.text));
      Navigator.pop(context);
      return;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _unitController = TextEditingController();
    _priceController = TextEditingController();

    if (widget.ingredient != null) {
      _nameController.text = widget.ingredient!.name;
      _quantityController.text = widget.ingredient!.quantity.toString();
      _unitController.text = widget.ingredient!.unit;
      _priceController.text = widget.ingredient!.value.toString();
    }
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ModalBarrier(color: Colors.black54),
        Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.ingredient == null
                          ? "Register Ingredient"
                          : "Update Ingredient",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(labelText: 'Unit'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.deepPurple[100]),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.deepPurple[400])),
                      onPressed:
                          widget.ingredient == null ? _register : _update,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
