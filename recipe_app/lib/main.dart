import 'dart:convert';

import 'package:flutter/material.dart';

import 'data/recipes_data.dart';
import 'models/recipe.dart';
import 'screens/recipe_list_screen.dart';

void main() {
  // ── JSON Parsing ──────────────────────────────────────────────────────────
  // 1. Decode the raw JSON string into a Dart Map.
  final Map<String, dynamic> decoded = jsonDecode(recipesJson);

  // 2. Extract the "recipes" array and map each element into a Recipe object.
  final List<Recipe> recipes = (decoded['recipes'] as List)
      .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
      .toList();
  // ─────────────────────────────────────────────────────────────────────────

  runApp(RecipeApp(recipes: recipes));
}

class RecipeApp extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeApp({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: RecipeListScreen(recipes: recipes),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6B35),
        brightness: Brightness.dark,
      ).copyWith(
        surface: const Color(0xFF121212),
        surfaceContainerHighest: const Color(0xFF1E1E1E),
        primary: const Color(0xFFFF6B35),
        secondary: const Color(0xFFFFB347),
      ),
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
