class Ingredient {
  final int id;
  final String name;
  final double value;
  final double quantity;
  final String unit;

  Ingredient(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.unit,
      required this.value});

  @override
  String toString() {
    return '$name ($unit)';
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
      value: json['value'],
    );
  }
}
