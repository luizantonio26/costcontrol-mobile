import 'package:flutter/material.dart';
import 'package:mobile/services/ingredient_service.dart';

class RegisterIngredient extends StatefulWidget {
  const RegisterIngredient({super.key});

  @override
  State<RegisterIngredient> createState() => _RegisterIngredientState();
}

class _RegisterIngredientState extends State<RegisterIngredient> {
  IngredientService ingredientService = IngredientService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
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
                      "Register",
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
                      onPressed: _register,
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
