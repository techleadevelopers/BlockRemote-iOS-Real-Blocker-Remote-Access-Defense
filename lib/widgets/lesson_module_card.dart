import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';
import '../models/lesson.dart';

class LessonModuleCard extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonModuleCard({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  @override
  State<LessonModuleCard> createState() => _LessonModuleCardState();
}

class _LessonModuleCardState extends State<LessonModuleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  Color _getDifficultyColor() {
    switch (widget.lesson.difficulty) {
      case 'Beginner':
        return BilinguiColors.successGreen;
      case 'Intermediate':
        return BilinguiColors.warningAmber;
      case 'Advanced':
        return BilinguiColors.accentPink;
      default:
        return BilinguiColors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          if (!widget.lesson.isLocked) widget.onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        child: Hero(
          tag: 'lesson_${widget.lesson.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.lesson.isLocked
                    ? BilinguiColors.lavender.withOpacity(0.5)
                    : BilinguiColors.cardSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.lesson.isLocked
                      ? Colors.grey.withOpacity(0.2)
                      : BilinguiColors.softLilac.withOpacity(0.4),
                ),
                boxShadow: widget.lesson.isLocked
                    ? []
                    : [
                        BoxShadow(
                          color: BilinguiColors.deepPurple.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: widget.lesson.isLocked
                          ? null
                          : BilinguiColors.primaryGradient,
                      color: widget.lesson.isLocked ? Colors.grey[300] : null,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      widget.lesson.isLocked ? Icons.lock : widget.lesson.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.lesson.title,
                                style: AppFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: widget.lesson.isLocked
                                      ? Colors.grey
                                      : BilinguiColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor().withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.lesson.difficulty,
                                style: AppFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getDifficultyColor(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.lesson.subtitle,
                          style: AppFonts.poppins(
                            fontSize: 13,
                            color: BilinguiColors.textSecondary,
                          ),
                        ),
                        if (!widget.lesson.isLocked) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: widget.lesson.progress,
                                    backgroundColor: BilinguiColors.softLilac.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      BilinguiColors.deepPurple,
                                    ),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '+${widget.lesson.xpReward} XP',
                                style: AppFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: BilinguiColors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!widget.lesson.isLocked) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: BilinguiColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
