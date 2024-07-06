import 'package:flutter/material.dart';
import 'package:mobile/models/recipe.dart';
import 'package:mobile/pages/recipe_detail.dart';
import 'package:mobile/pages/register_recipe.dart';
import 'package:mobile/services/recipe_service.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  late Future<List<Recipe>> futureRecipes;
  RecipeService recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    futureRecipes = recipeService.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return RegisterRecipe();
            },
          ).then((_) {
            setState(() {
              futureRecipes = recipeService.fetchRecipes();
            });
          });
        },
        foregroundColor: Colors.deepPurple[100],
        backgroundColor: Colors.deepPurple[600],
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Recipe recipe = snapshot.data![index];
                return Card(
                  // child: Column(
                  //   children: [
                  //     recipe.imageUrl != null
                  //         ? Image.network(
                  //             "http://192.168.0.189:8000/recipe/image/${recipe.imageUrl}"!,
                  //             width: MediaQuery.sizeOf(context).width * 0.35,
                  //             height: MediaQuery.sizeOf(context).height * 0.20,
                  //             fit: BoxFit.cover)
                  //         : Image.network(
                  //             "https://as2.ftcdn.net/v2/jpg/04/70/29/97/1000_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg",
                  //             width: MediaQuery.sizeOf(context).width * 0.35,
                  //             height: MediaQuery.sizeOf(context).height * 0.20,
                  //             fit: BoxFit.cover),
                  //   ],
                  // ),
                  child: ListTile(
                    leading: recipe.imageUrl != null
                        ? Image.network(
                            "http://192.168.0.189:8000/recipe/media/images/${recipe.imageUrl}"!,
                            width: 120,
                            height: 200,
                            fit: BoxFit.cover)
                        : Image.network(
                            "https://as2.ftcdn.net/v2/jpg/04/70/29/97/1000_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg",
                            width: 120,
                            height: 200,
                            fit: BoxFit
                                .fill), // Default icon if imageUrl is null
                    title: Text(recipe.name),
                    subtitle: Text(
                        'Prep Time: ${recipe.prepTime}\nServings: ${recipe.servings}\nCost: \$${recipe.recipeCost.toStringAsFixed(2)}\nCost per Unit: \$${recipe.recipeCostPerUnit.toStringAsFixed(2)}'),
                    trailing:
                        Text('${recipe.createdAt.toLocal()}'.split(' ')[0]),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RecipeDetail(id: recipe.id)));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
