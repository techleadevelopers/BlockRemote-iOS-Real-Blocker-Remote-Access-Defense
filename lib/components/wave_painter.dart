import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double amplitude;
  final double frequency;
  final double noiseLevel;

  WavePainter({
    required this.animationValue,
    this.color = AppColors.primaryNeon,
    this.amplitude = 30.0,
    this.frequency = 2.0,
    this.noiseLevel = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final random = Random(42);

    for (int layer = 0; layer < 3; layer++) {
      final path = Path();
      final layerOpacity = 1.0 - (layer * 0.3);
      final layerOffset = layer * 0.3;
      final actualAmplitude = amplitude * (1.0 + noiseLevel * 0.5);

      paint.color = color.withValues(alpha: layerOpacity);

      for (double x = 0; x <= size.width; x += 1) {
        final normalizedX = x / size.width;
        final wave1 = sin(
          (normalizedX * frequency * 2 * pi) +
              (animationValue * 2 * pi) +
              layerOffset,
        );
        final wave2 = sin(
          (normalizedX * frequency * 1.5 * 2 * pi) +
              (animationValue * 2 * pi * 1.3) +
              layerOffset * 2,
        );
        final noise =
            noiseLevel > 0.3 ? (random.nextDouble() - 0.5) * noiseLevel * 20 : 0.0;

        final y = size.height / 2 +
            (wave1 * actualAmplitude * 0.7 +
                wave2 * actualAmplitude * 0.3 +
                noise);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      if (layer == 0) {
        canvas.drawPath(path, glowPaint);
      }
      canvas.drawPath(path, paint);
    }

    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;

    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.noiseLevel != noiseLevel ||
      oldDelegate.color != color ||
      oldDelegate.amplitude != amplitude ||
      oldDelegate.frequency != frequency;
}
