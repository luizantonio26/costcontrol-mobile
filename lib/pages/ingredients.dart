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
                  child: ListTile(
                    // leading: Text(ingredient.id.toString()),
                    title: Text(ingredient.name),
                    subtitle: Text(
                        'Quantity: ${ingredient.quantity} ${ingredient.unit}'),
                    trailing: Text("Price: R\$ ${ingredient.value.toString()}"),
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
