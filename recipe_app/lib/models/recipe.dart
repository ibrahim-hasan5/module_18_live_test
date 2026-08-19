/// Data model representing a single recipe.
class Recipe {
  final String title;
  final String description;
  final List<String> ingredients;

  const Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
  });

  /// Parses a [Recipe] from a JSON map.
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] as String,
      description: json['description'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
    );
  }

  /// Converts the [Recipe] back to a JSON map.
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'ingredients': ingredients,
      };

  @override
  String toString() => 'Recipe(title: $title)';
}
