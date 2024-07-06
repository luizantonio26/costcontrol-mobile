import 'package:flutter/material.dart';
import 'package:mobile/models/recipe.dart';
import 'package:mobile/pages/recipe_detail_register.dart';
import 'package:mobile/services/recipe_service.dart';
import 'package:mobile/widgets/app_bar.dart';

class RecipeDetail extends StatefulWidget {
  final int id;
  RecipeDetail({super.key, required this.id});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  late int _id;
  late Future<Recipe> _recipe;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _recipe = RecipeService().fetchRecipe(_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isLogin: false),
      body: FutureBuilder<Recipe>(
        future: _recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.id == null) {
            return const Center(child: Text('No recipe found'));
          } else {
            Recipe recipe = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Center(
                    child: recipe.imageUrl != null
                        ? Image.network(
                            "http://192.168.0.189:8000/recipe/media/images/${recipe.imageUrl}"!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 50),
                  ),
                  Center(
                    child: Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Cooking time: " + recipe.prepTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Servings: " + recipe.servings.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Cost: R\$" + recipe.recipeCost.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Cost per unit: R\$" +
                        recipe.recipeCostPerUnit.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Ingredients",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipe.ingredients!.length,
                    itemBuilder: (context, index) {
                      if (recipe.ingredients!.length == 0) {
                        return const Text("No ingredients found");
                      }
                      Map<String, dynamic> ingredient =
                          recipe.ingredients![index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            ingredient['ingredients']['name'],
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            "Quantity: " +
                                ingredient['quantity'].toString() +
                                " " +
                                ingredient['ingredients']['unit'],
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Text(
                            "Cost: R\$ " +
                                ingredient['value'].toStringAsFixed(2),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return RecipeDetailRegister(
                recipe_id: _id,
              );
            },
          ).then((_) {
            setState(() {
              _recipe = RecipeService().fetchRecipe(_id);
            });
          });
        },
        backgroundColor: Colors.deepPurple[600],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
