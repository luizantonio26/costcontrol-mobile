import 'package:mobile/models/ingredient.dart';

class RecipeIngredient {
  final int id;
  final double quantity;
  final double value;
  final Ingredient ingredient;

  RecipeIngredient({
    required this.id,
    required this.quantity,
    required this.value,
    required this.ingredient,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'],
      quantity: json['quantity'].toDouble(),
      value: json['value'].toDouble(),
      ingredient: Ingredient.fromJson(json['ingredient']),
    );
  }
}

class Recipe {
  final int id;
  final String name;
  final String prepTime;
  final int servings;
  final String? imageUrl;
  final double recipeCost;
  final double recipeCostPerUnit;
  final DateTime createdAt;
  final List<dynamic>? ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.prepTime,
    required this.servings,
    required this.imageUrl,
    required this.recipeCost,
    required this.recipeCostPerUnit,
    required this.createdAt,
    this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      prepTime: json['prep_time'],
      servings: json['servings'],
      imageUrl: json['image_url'],
      recipeCost: json['recipe_cost'].toDouble(),
      recipeCostPerUnit: json['recipe_cost_per_unit'].toDouble(),
      ingredients: json['ingredients'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
