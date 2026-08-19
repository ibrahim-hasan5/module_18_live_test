import 'package:flutter/material.dart';

import '../models/recipe.dart';

/// Reusable animated tile for displaying a single recipe in the list.
class RecipeListTile extends StatefulWidget {
  final Recipe recipe;
  final int index;
  final String emoji;
  final VoidCallback onTap;

  const RecipeListTile({
    super.key,
    required this.recipe,
    required this.index,
    required this.emoji,
    required this.onTap,
  });

  @override
  State<RecipeListTile> createState() => _RecipeListTileState();
}

class _RecipeListTileState extends State<RecipeListTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Stagger the entrance animation by index
    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = _indexColor(widget.index, colorScheme);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translateByDouble(0.0, _isHovered ? -3.0 : 0.0, 0.0, 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: _isHovered
                    ? accentColor.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.05),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? accentColor.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.3),
                  blurRadius: _isHovered ? 20 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(18),
                splashColor: accentColor.withValues(alpha: 0.15),
                highlightColor: accentColor.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // ── Emoji avatar ──────────────────────────────────
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentColor.withValues(alpha: 0.25),
                              accentColor.withValues(alpha: 0.10),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // ── Text content ──────────────────────────────────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.recipe.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.recipe.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: colorScheme.onSurface.withValues(alpha: 0.55),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Ingredient count chip
                            _IngredientChip(
                              count: widget.recipe.ingredients.length,
                              color: accentColor,
                            ),
                          ],
                        ),
                      ),

                      // ── Index badge ───────────────────────────────────
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentColor.withValues(alpha: 0.15),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${widget.index + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a distinct accent color per list position.
  Color _indexColor(int index, ColorScheme cs) {
    const palette = [
      Color(0xFFFF6B35), // orange
      Color(0xFF4ECDC4), // teal
      Color(0xFFFFE66D), // yellow
      Color(0xFF95E1D3), // mint
      Color(0xFFF38181), // pink-red
      Color(0xFFA8E6CF), // green
      Color(0xFFDDA0DD), // plum
    ];
    return palette[index % palette.length];
  }
}

class _IngredientChip extends StatelessWidget {
  final int count;
  final Color color;

  const _IngredientChip({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$count ingredient${count == 1 ? '' : 's'}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
