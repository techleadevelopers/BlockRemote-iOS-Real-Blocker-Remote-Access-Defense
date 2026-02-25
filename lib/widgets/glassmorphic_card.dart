import 'package:flutter/material.dart';
import '../theme/bilingui_theme.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: BilinguiColors.deepPurple.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: BilinguiColors.softLilac.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}
