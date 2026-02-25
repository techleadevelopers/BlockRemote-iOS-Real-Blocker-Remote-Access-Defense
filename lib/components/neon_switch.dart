import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const NeonSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.primaryNeon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value
              ? activeColor.withValues(alpha: 0.2)
              : AppColors.surfaceLight,
          border: Border.all(
            color: value
                ? activeColor
                : AppColors.text.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? activeColor : AppColors.text.withValues(alpha: 0.4),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}
