import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final Color borderColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.sigmaX = 20.0,
    this.sigmaY = 20.0,
    this.borderColor = AppColors.glassBorder,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(0);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface.withValues(alpha: 0.75),
                AppColors.surface.withValues(alpha: 0.55),
              ],
            ),
            borderRadius: radius,
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 0.5,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
