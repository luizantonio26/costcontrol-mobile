import 'package:flutter/material.dart';
import 'package:mobile/models/ingredient.dart';
import 'package:mobile/pages/register_ingredient.dart';
import 'package:mobile/services/ingredient_service.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({super.key});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  late Future<List<Ingredient>> futureIngredients;
  IngredientService ingredientService = IngredientService();

  @override
  void initState() {
    super.initState();
    futureIngredients = ingredientService.fetchIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return RegisterIngredient();
            },
          ).then((_) {
            setState(() {
              futureIngredients = ingredientService.fetchIngredients();
            });
          });
        },
        tooltip: 'Add Ingredient',
        mini: true,
        foregroundColor: Colors.deepPurple[100],
        backgroundColor: Colors.deepPurple[600],
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Ingredient>>(
        future: futureIngredients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Ingredient ingredient = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    key: ValueKey(ingredient.id),
                    // leading: Text(ingredient.id.toString()),
                    title: Text(ingredient.name),
                    subtitle: Text(
                        'Quantity: ${ingredient.quantity} ${ingredient.unit} \nPrice: R\$ ${ingredient.value.toStringAsFixed(2)}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String result) {
                        switch (result) {
                          case 'edit':
                            // Adicione a lógica de edição aqui
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return RegisterIngredient(
                                  ingredient: ingredient,
                                );
                              },
                            ).then((_) {
                              setState(() {
                                futureIngredients =
                                    ingredientService.fetchIngredients();
                              });
                            });
                            break;
                          case 'delete':
                            // Adicione a lógica de exclusão aqui
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm deletion'),
                                  content: Text(
                                      'Are you sure you want to delete ${ingredient.name}?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        ingredientService
                                            .deleteIngredient(ingredient.id);
                                        setState(() {
                                          futureIngredients = ingredientService
                                              .fetchIngredients();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
