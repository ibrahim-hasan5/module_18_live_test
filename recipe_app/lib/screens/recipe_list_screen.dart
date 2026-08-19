import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../widgets/recipe_list_tile.dart';
import 'recipe_detail_screen.dart';

/// Main screen that renders the list of recipes parsed from JSON.
class RecipeListScreen extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeListScreen({super.key, required this.recipes});

  // Emoji icon mapping per recipe for visual flair
  static const Map<String, String> _emojiMap = {
    'Pasta Carbonara': '🍝',
    'Caprese Salad': '🥗',
    'Banana Smoothie': '🍌',
    'Chicken Stir-Fry': '🍗',
    'Grilled Salmon': '🐟',
    'Vegetable Curry': '🍛',
    'Berry Parfait': '🍓',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsing App Bar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipe Book',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    '${recipes.length} delicious recipes',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              background: _AppBarBackground(colorScheme: colorScheme),
            ),
          ),

          // ── JSON Badge ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: _JsonBadge(recipeCount: recipes.length),
            ),
          ),

          // ── Recipe ListView ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList.separated(
              itemCount: recipes.length,
              separatorBuilder: (_, _x) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeListTile(
                  recipe: recipe,
                  index: index,
                  emoji: _emojiMap[recipe.title] ?? '🍽️',
                  onTap: () => Navigator.push(
                    context,
                    _FadeRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _AppBarBackground extends StatelessWidget {
  final ColorScheme colorScheme;

  const _AppBarBackground({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.25),
            colorScheme.secondary.withValues(alpha: 0.10),
            colorScheme.surface,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 60,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondary.withValues(alpha: 0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JsonBadge extends StatelessWidget {
  final int recipeCount;

  const _JsonBadge({required this.recipeCount});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.data_object_rounded,
              size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.5,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                children: [
                  const TextSpan(text: 'Parsed from '),
                  TextSpan(
                    text: 'JSON',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const TextSpan(text: ' · '),
                  TextSpan(
                    text: '$recipeCount items',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' · via '),
                  TextSpan(
                    text: 'Recipe.fromJson()',
                    style: TextStyle(
                      color: colorScheme.primary.withValues(alpha: 0.85),
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom page route with a fade transition.
class _FadeRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  _FadeRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
        );
}
