import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';

class GlassContainer extends ConsumerWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeState = ref.watch(themeProvider);
    final isFrosted = themeState.isFrostedGlassEnabled;
    final isMatteBlack = themeState.currentPalette.id == 'matte_black';

    final defaultGlassBg = isDark
        ? (isMatteBlack
            ? const Color(0xFF0E0E11).withValues(alpha: 0.90)
            : theme.colorScheme.surface.withValues(alpha: 0.65))
        : Colors.white.withValues(alpha: 0.82);

    final defaultSolidBg = isDark
        ? (isMatteBlack ? const Color(0xFF0E0E11) : theme.colorScheme.surface)
        : Colors.white;

    final defaultBorder = border ??
        Border.all(
          color: isMatteBlack
              ? const Color(0xFF2B2D30)
              : (isFrosted
                  ? (isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.6))
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06))),
          width: 1,
        );

    final effectiveShadow = boxShadow ??
        (isFrosted
            ? [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.18)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]);

    Widget content;

    if (isFrosted) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? defaultGlassBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: defaultBorder,
              boxShadow: effectiveShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: child,
            ),
          ),
        ),
      );
    } else {
      content = AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? defaultSolidBg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: defaultBorder,
          boxShadow: effectiveShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }
}
