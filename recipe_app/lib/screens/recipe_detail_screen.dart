import 'package:flutter/material.dart';

import '../models/recipe.dart';

/// Detail screen showing all fields of a [Recipe].
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: colorScheme.surface,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colorScheme.onSurface,
                  size: 18,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              title: Text(
                recipe.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.2),
                      colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _SectionCard(
                    icon: Icons.description_outlined,
                    label: 'Description',
                    colorScheme: colorScheme,
                    child: Text(
                      recipe.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurface.withValues(alpha: 0.85),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ingredients
                  _SectionCard(
                    icon: Icons.restaurant_menu_outlined,
                    label: 'Ingredients (${recipe.ingredients.length})',
                    colorScheme: colorScheme,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipe.ingredients
                          .map((ing) => _IngredientTag(
                                ingredient: ing,
                                colorScheme: colorScheme,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Data model info card
                  _DataModelCard(recipe: recipe, colorScheme: colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                  letterSpacing: 0.5,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _IngredientTag extends StatelessWidget {
  final String ingredient;
  final ColorScheme colorScheme;

  const _IngredientTag(
      {required this.ingredient, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            ingredient,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataModelCard extends StatelessWidget {
  final Recipe recipe;
  final ColorScheme colorScheme;

  const _DataModelCard(
      {required this.recipe, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code_rounded,
                  size: 15, color: colorScheme.secondary),
              const SizedBox(width: 6),
              Text(
                'Recipe.fromJson() — data model',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.secondary,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _CodeLine(
              label: 'title',
              value: '"${recipe.title}"',
              colorScheme: colorScheme),
          _CodeLine(
              label: 'description',
              value: '"${recipe.description}"',
              colorScheme: colorScheme,
              truncate: true),
          _CodeLine(
              label: 'ingredients',
              value: '[${recipe.ingredients.length} items]',
              colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final bool truncate;

  const _CodeLine({
    required this.label,
    required this.value,
    required this.colorScheme,
    this.truncate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.primary.withValues(alpha: 0.8),
              fontFamily: 'monospace',
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: truncate ? 1 : null,
              overflow:
                  truncate ? TextOverflow.ellipsis : TextOverflow.visible,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.secondary.withValues(alpha: 0.9),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
