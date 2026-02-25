import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/bilingui_theme.dart';
import '../theme/app_fonts.dart';

class CyberLoading extends StatefulWidget {
  final double size;
  final String? message;
  const CyberLoading({super.key, this.size = 80, this.message});

  @override
  State<CyberLoading> createState() => _CyberLoadingState();
}

class _CyberLoadingState extends State<CyberLoading>
    with TickerProviderStateMixin {
  late final AnimationController _spinController;
  late final AnimationController _pulseController;
  late final AnimationController _glitchController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_spinController, _pulseController, _glitchController]),
          builder: (context, child) {
            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _CyberPainter(
                  spinProgress: _spinController.value,
                  pulseValue: _pulseAnim.value,
                  glitchProgress: _glitchController.value,
                ),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.5 + _pulseAnim.value * 0.5,
                child: Text(
                  widget.message!,
                  style: AppFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: BilinguiColors.deepPurple,
                    letterSpacing: 2.0,
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _CyberPainter extends CustomPainter {
  final double spinProgress;
  final double pulseValue;
  final double glitchProgress;

  _CyberPainter({
    required this.spinProgress,
    required this.pulseValue,
    required this.glitchProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width / 2;

    _drawOuterRing(canvas, center, maxR);
    _drawMiddleArcs(canvas, center, maxR * 0.72);
    _drawInnerDots(canvas, center, maxR * 0.45);
    _drawCenterCore(canvas, center, maxR * 0.18);
    _drawGlitchLines(canvas, size);
  }

  void _drawOuterRing(Canvas canvas, Offset center, double radius) {
    final angle = spinProgress * 2 * math.pi;

    final bgPaint = Paint()
      ..color = const Color(0xFF6A11CB).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, bgPaint);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    const segments = 3;
    const gap = math.pi / 6;
    final segLen = (2 * math.pi - segments * gap) / segments;

    for (int i = 0; i < segments; i++) {
      final startA = angle + i * (segLen + gap);
      final t = i / segments;
      final color = Color.lerp(
        const Color(0xFF6A11CB),
        const Color(0xFFB388FF),
        t,
      )!;
      arcPaint.color = color.withOpacity(0.6 + pulseValue * 0.4);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startA,
        segLen,
        false,
        arcPaint,
      );
    }

    final tickCount = 12;
    final tickPaint = Paint()
      ..color = const Color(0xFFB388FF).withOpacity(0.3 + pulseValue * 0.2)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < tickCount; i++) {
      final a = (i / tickCount) * 2 * math.pi;
      final inner = radius - 5;
      final outer = radius + 3;
      canvas.drawLine(
        Offset(center.dx + inner * math.cos(a), center.dy + inner * math.sin(a)),
        Offset(center.dx + outer * math.cos(a), center.dy + outer * math.sin(a)),
        tickPaint,
      );
    }
  }

  void _drawMiddleArcs(Canvas canvas, Offset center, double radius) {
    final angle = -spinProgress * 2 * math.pi * 1.4;

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    const segments = 2;
    const segLen = math.pi * 0.6;
    const gap = math.pi;

    for (int i = 0; i < segments; i++) {
      final startA = angle + i * (segLen + gap);
      arcPaint.color = const Color(0xFF9B59E0).withOpacity(0.5 + pulseValue * 0.3);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startA,
        segLen,
        false,
        arcPaint,
      );
    }
  }

  void _drawInnerDots(Canvas canvas, Offset center, double radius) {
    final angle = spinProgress * 2 * math.pi * 0.7;
    final dotCount = 8;
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < dotCount; i++) {
      final a = angle + (i / dotCount) * 2 * math.pi;
      final t = i / dotCount;
      final opacity = (0.2 + 0.8 * ((math.sin(spinProgress * 2 * math.pi + t * math.pi * 2) + 1) / 2));
      dotPaint.color = Color.lerp(
        const Color(0xFF6A11CB),
        const Color(0xFFE0C3FC),
        t,
      )!.withOpacity(opacity * (0.5 + pulseValue * 0.5));

      final dotSize = 2.0 + 1.5 * opacity;
      canvas.drawCircle(
        Offset(center.dx + radius * math.cos(a), center.dy + radius * math.sin(a)),
        dotSize,
        dotPaint,
      );
    }
  }

  void _drawCenterCore(Canvas canvas, Offset center, double radius) {
    final coreRadius = radius * (0.7 + pulseValue * 0.3);

    final outerGlow = Paint()
      ..color = const Color(0xFFB388FF).withOpacity(0.15 * pulseValue)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, coreRadius * 2.5, outerGlow);

    final corePaint = Paint()
      ..color = const Color(0xFF6A11CB).withOpacity(0.6 + pulseValue * 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, coreRadius, corePaint);

    final innerPaint = Paint()
      ..color = const Color(0xFFB388FF).withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, coreRadius * 0.4, innerPaint);
  }

  void _drawGlitchLines(Canvas canvas, Size size) {
    final glitchPhase = (glitchProgress * 4) % 1.0;
    if (glitchPhase > 0.85) {
      final linePaint = Paint()
        ..color = const Color(0xFFB388FF).withOpacity(0.15)
        ..strokeWidth = 1.0;

      final y1 = size.height * 0.3 + glitchPhase * 20;
      final y2 = size.height * 0.7 - glitchPhase * 15;

      canvas.drawLine(
        Offset(0, y1),
        Offset(size.width * 0.3, y1),
        linePaint,
      );
      canvas.drawLine(
        Offset(size.width * 0.7, y2),
        Offset(size.width, y2),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CyberPainter oldDelegate) => true;
}
