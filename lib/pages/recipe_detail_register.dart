import 'package:flutter/material.dart';
import 'package:mobile/models/ingredient.dart';
import 'package:mobile/services/ingredient_service.dart';
import 'package:mobile/services/recipe_service.dart';

class RecipeDetailRegister extends StatefulWidget {
  final int recipe_id;

  const RecipeDetailRegister({super.key, required this.recipe_id});

  @override
  State<RecipeDetailRegister> createState() => _RecipeDetailRegisterState();
}

class _RecipeDetailRegisterState extends State<RecipeDetailRegister> {
  late Future<List<Ingredient>> _ingredientsList;
  late Ingredient _selectedIngredient;
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ingredientsList = IngredientService().fetchIngredients();
  }

  void _addIngredientToRecipe() {
    // Add ingredient to recipe
    if (_selectedIngredient != null && _quantityController.text.isNotEmpty) {
      RecipeService().addIngredient(widget.recipe_id, _selectedIngredient.id,
          double.parse(_quantityController.text));
      Navigator.pop(context);
    }
  }

  @override
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
                      "Add Ingredient to the recipe",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: FutureBuilder<List<Ingredient>>(
                        future: _ingredientsList, // Fetch data from API
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Autocomplete<Ingredient>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                return snapshot.data!
                                    .where((e) =>
                                        e.name.contains(textEditingValue.text))
                                    .toList();
                              },
                              onSelected: (Ingredient selection) {
                                // Handle selection
                                setState(() {
                                  _selectedIngredient = selection;
                                });
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                  ),
                                  onSubmitted: (String value) {
                                    onFieldSubmitted();
                                  },
                                );
                              },
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
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
                        onPressed: _addIngredientToRecipe),
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
