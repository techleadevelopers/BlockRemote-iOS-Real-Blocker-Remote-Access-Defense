import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CyberButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final bool isOutlined;
  final double width;
  final bool heavyHaptic;

  const CyberButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primaryNeon,
    this.icon,
    this.isOutlined = false,
    this.width = double.infinity,
    this.heavyHaptic = false,
  });

  @override
  State<CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<CyberButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _glowAnimation.value * 0.4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: widget.color.withValues(alpha: _glowAnimation.value * 0.15),
                blurRadius: 40,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (widget.heavyHaptic) {
                  HapticFeedback.heavyImpact();
                } else {
                  HapticFeedback.mediumImpact();
                }
                widget.onPressed();
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withValues(alpha: 0.2),
                      widget.color.withValues(alpha: 0.08),
                      widget.color.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: widget.color, size: 20),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.label,
                      style: AppFonts.mono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: widget.color,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
