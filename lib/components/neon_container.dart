import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonContainer extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double glowIntensity;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final bool useGradient;
  final VoidCallback? onTap;

  const NeonContainer({
    super.key,
    required this.child,
    this.glowColor = AppColors.primaryNeon,
    this.glowIntensity = 0.3,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 12,
    this.useGradient = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: useGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface,
                  AppColors.surfaceLight.withValues(alpha: 0.7),
                  AppColors.surface,
                ],
                stops: const [0.0, 0.5, 1.0],
              )
            : null,
        color: useGradient ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: glowColor.withValues(alpha: glowIntensity * 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: glowIntensity * 0.3),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: glowIntensity * 0.1),
            blurRadius: 40,
            spreadRadius: -4,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }
    return container;
  }
}
