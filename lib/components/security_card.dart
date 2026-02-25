import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SecurityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color statusColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SecurityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.statusColor = AppColors.primaryNeon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.surfaceLight.withValues(alpha: 0.5),
              AppColors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: statusColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.heading(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppFonts.heading(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.chevron_right,
                  color: statusColor.withValues(alpha: 0.4),
                  size: 18,
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
