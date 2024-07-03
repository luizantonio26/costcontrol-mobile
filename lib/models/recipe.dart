class Recipe {
  final int id;
  final String name;
  final String prepTime;
  final int servings;
  final String? imageUrl;
  final double recipeCost;
  final double recipeCostPerUnit;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.name,
    required this.prepTime,
    required this.servings,
    required this.imageUrl,
    required this.recipeCost,
    required this.recipeCostPerUnit,
    required this.createdAt,
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
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
