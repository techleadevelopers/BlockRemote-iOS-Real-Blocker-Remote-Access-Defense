import 'package:flutter/material.dart';
import '../theme/bilingui_theme.dart';

class AnimatedBrainLogo extends StatefulWidget {
  final double size;
  const AnimatedBrainLogo({super.key, this.size = 120});

  @override
  State<AnimatedBrainLogo> createState() => _AnimatedBrainLogoState();
}

class _AnimatedBrainLogoState extends State<AnimatedBrainLogo>
    with TickerProviderStateMixin {
  late final AnimationController _breatheController;
  late final AnimationController _glowController;
  late final Animation<double> _breatheAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _breatheAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breatheController, _glowController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _breatheAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: BilinguiColors.deepPurple.withOpacity(_glowAnimation.value),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: BilinguiColors.softLilac.withOpacity(_glowAnimation.value * 0.4),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              'assets/logo.png',
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
