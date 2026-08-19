import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/data/recipes_data.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/recipe.dart';

void main() {
  // ── Unit tests: JSON parsing & data model ──────────────────────────────────
  group('Recipe.fromJson()', () {
    test('parses title correctly', () {
      final json = {
        'title': 'Pasta Carbonara',
        'description': 'Creamy pasta dish.',
        'ingredients': ['spaghetti', 'bacon'],
      };
      final recipe = Recipe.fromJson(json);
      expect(recipe.title, 'Pasta Carbonara');
    });

    test('parses description correctly', () {
      final json = {
        'title': 'Test',
        'description': 'Test description',
        'ingredients': [],
      };
      final recipe = Recipe.fromJson(json);
      expect(recipe.description, 'Test description');
    });

    test('parses ingredients list correctly', () {
      final json = {
        'title': 'Test',
        'description': 'Desc',
        'ingredients': ['a', 'b', 'c'],
      };
      final recipe = Recipe.fromJson(json);
      expect(recipe.ingredients, ['a', 'b', 'c']);
      expect(recipe.ingredients.length, 3);
    });

    test('parses all 7 recipes from embedded JSON', () {
      final decoded = jsonDecode(recipesJson) as Map<String, dynamic>;
      final recipes = (decoded['recipes'] as List)
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(recipes.length, 7);
      expect(recipes.first.title, 'Pasta Carbonara');
      expect(recipes.last.title, 'Berry Parfait');
    });
  });

  // ── Widget test: RecipeApp renders recipe titles ───────────────────────────
  group('RecipeApp widget', () {
    late List<Recipe> recipes;

    setUp(() {
      final decoded = jsonDecode(recipesJson) as Map<String, dynamic>;
      recipes = (decoded['recipes'] as List)
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    testWidgets('displays all recipe titles in ListView',
        (WidgetTester tester) async {
      await tester.pumpWidget(RecipeApp(recipes: recipes));
      await tester.pumpAndSettle();

      // Verify the app bar title is present
      expect(find.text('Recipe Book'), findsWidgets);

      // Verify each recipe title appears in the list
      for (final recipe in recipes) {
        expect(find.text(recipe.title), findsOneWidget);
      }
    });

    testWidgets('shows correct number of recipes', (WidgetTester tester) async {
      await tester.pumpWidget(RecipeApp(recipes: recipes));
      await tester.pumpAndSettle();
      expect(recipes.length, 7);
    });
  });
}
