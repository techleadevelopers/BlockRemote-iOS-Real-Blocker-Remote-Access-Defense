import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';
import '../models/user_stats.dart';
import 'glassmorphic_card.dart';

class _SkillData {
  final String name;
  final IconData icon;
  final double value;
  final Color startColor;
  final Color endColor;

  const _SkillData({
    required this.name,
    required this.icon,
    required this.value,
    required this.startColor,
    required this.endColor,
  });
}

class SkillActivityRings extends StatefulWidget {
  final UserStats stats;
  const SkillActivityRings({super.key, required this.stats});

  @override
  State<SkillActivityRings> createState() => _SkillActivityRingsState();
}

class _SkillActivityRingsState extends State<SkillActivityRings>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _entryController;

  List<_SkillData> get _skills => [
        _SkillData(
          name: 'Speaking',
          icon: Icons.mic,
          value: widget.stats.speakingScore,
          startColor: const Color(0xFF6A11CB),
          endColor: const Color(0xFF9B59E0),
        ),
        _SkillData(
          name: 'Reading',
          icon: Icons.menu_book,
          value: widget.stats.readingScore,
          startColor: const Color(0xFF7B2FDB),
          endColor: const Color(0xFFAB6FEF),
        ),
        _SkillData(
          name: 'Grammar',
          icon: Icons.spellcheck,
          value: widget.stats.grammarScore,
          startColor: const Color(0xFF8E44EC),
          endColor: const Color(0xFFBE8AF5),
        ),
        _SkillData(
          name: 'Listening',
          icon: Icons.headphones,
          value: widget.stats.listeningScore,
          startColor: const Color(0xFFA35BF0),
          endColor: const Color(0xFFCFA5F8),
        ),
        _SkillData(
          name: 'Writing',
          icon: Icons.edit_note,
          value: widget.stats.writingScore,
          startColor: const Color(0xFFB872F5),
          endColor: const Color(0xFFE0C3FC),
        ),
      ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _onSkillTap(int index) {
    setState(() {
      _selectedIndex = _selectedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Skill Overview',
            style: AppFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: BilinguiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: AnimatedBuilder(
              animation: _entryController,
              builder: (context, child) {
                return SizedBox(
                  height: 240,
                  width: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(240, 240),
                        painter: _RingsPainter(
                          skills: _skills,
                          progress: CurvedAnimation(
                            parent: _entryController,
                            curve: Curves.easeOutCubic,
                          ).value,
                          selectedIndex: _selectedIndex,
                        ),
                      ),
                      _buildCenterLabel(),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildCenterLabel() {
    final String label;
    final String sub;

    if (_selectedIndex != null) {
      final skill = _skills[_selectedIndex!];
      label = '${(skill.value * 100).toInt()}%';
      sub = skill.name;
    } else {
      label = 'Level ${widget.stats.level}';
      sub = 'Explorer';
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        key: ValueKey('$label-$sub'),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: BilinguiColors.deepPurple,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: AppFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: BilinguiColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(_skills.length, (i) {
        final skill = _skills[i];
        final isSelected = _selectedIndex == i;

        return GestureDetector(
          onTap: () => _onSkillTap(i),
          child: AnimatedScale(
            scale: isSelected ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 500),
            curve: isSelected ? Curves.elasticOut : Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? skill.startColor.withOpacity(0.12)
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? skill.startColor.withOpacity(0.4)
                      : BilinguiColors.softLilac.withOpacity(0.3),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [skill.startColor, skill.endColor],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    skill.name,
                    style: AppFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? skill.startColor
                          : BilinguiColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(skill.value * 100).toInt()}%',
                    style: AppFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: isSelected
                          ? skill.startColor.withOpacity(0.8)
                          : BilinguiColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final List<_SkillData> skills;
  final double progress;
  final int? selectedIndex;

  _RingsPainter({
    required this.skills,
    required this.progress,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final ringWidth = 10.0;
    final ringGap = 5.0;
    final outerStart = maxRadius - 6;
    final segmentCount = 36;

    for (int i = 0; i < skills.length; i++) {
      final skill = skills[i];
      final isSelected = selectedIndex == i;
      final currentRingWidth = isSelected ? ringWidth + 3 : ringWidth;
      final ringRadius = outerStart - i * (ringWidth + ringGap);

      final bgPaint = Paint()
        ..color = skill.endColor.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = currentRingWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, ringRadius, bgPaint);

      final totalSweep = 2 * math.pi * skill.value * progress;
      final startAngle = -math.pi / 2;

      if (totalSweep > 0) {
        final segAngle = totalSweep / segmentCount;
        for (int s = 0; s < segmentCount; s++) {
          final t = s / (segmentCount - 1);
          final color = Color.lerp(skill.startColor, skill.endColor, t)!;
          final segStart = startAngle + s * segAngle;

          final arcPaint = Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = currentRingWidth
            ..strokeCap = StrokeCap.butt;

          canvas.drawArc(
            Rect.fromCircle(center: center, radius: ringRadius),
            segStart,
            segAngle + 0.01,
            false,
            arcPaint,
          );
        }

        final capPaint = Paint()
          ..color = skill.startColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = currentRingWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: ringRadius),
          startAngle,
          0.01,
          false,
          capPaint,
        );
        final endCapPaint = Paint()
          ..color = skill.endColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = currentRingWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: ringRadius),
          startAngle + totalSweep - 0.01,
          0.01,
          false,
          endCapPaint,
        );

        if (isSelected && progress >= 1.0) {
          final glowPaint = Paint()
            ..color = skill.startColor.withOpacity(0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = currentRingWidth + 8
            ..strokeCap = StrokeCap.round;

          canvas.drawArc(
            Rect.fromCircle(center: center, radius: ringRadius),
            startAngle,
            totalSweep,
            false,
            glowPaint,
          );
        }

        final endX = center.dx + ringRadius * math.cos(startAngle + totalSweep);
        final endY = center.dy + ringRadius * math.sin(startAngle + totalSweep);
        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(endX, endY), isSelected ? 4.0 : 3.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_RingsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
