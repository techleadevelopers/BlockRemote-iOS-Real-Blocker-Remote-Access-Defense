import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/bilingui_theme.dart';

class VoiceButton extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onPressed;

  const VoiceButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording) {
      _waveController.repeat();
      _pulseController.repeat(reverse: true);
    } else {
      _waveController.stop();
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _pulseController]),
      builder: (context, child) {
        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.isRecording) ..._buildWaveRings(),
              Transform.scale(
                scale: widget.isRecording ? _pulseAnimation.value : 1.0,
                child: GestureDetector(
                  onTap: widget.onPressed,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: BilinguiColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: BilinguiColors.deepPurple.withOpacity(0.4),
                          blurRadius: widget.isRecording ? 24 : 12,
                          spreadRadius: widget.isRecording ? 4 : 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildWaveRings() {
    return List.generate(3, (index) {
      final delay = index * 0.3;
      final progress = (_waveController.value + delay) % 1.0;
      final opacity = (1.0 - progress).clamp(0.0, 0.5);
      final scale = 1.0 + progress * 0.8;

      return Transform.scale(
        scale: scale,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: BilinguiColors.deepPurple.withOpacity(opacity),
              width: 2,
            ),
          ),
        ),
      );
    });
  }
}

class SineWaveWidget extends StatefulWidget {
  final bool isActive;
  const SineWaveWidget({super.key, required this.isActive});

  @override
  State<SineWaveWidget> createState() => _SineWaveWidgetState();
}

class _SineWaveWidgetState extends State<SineWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    if (widget.isActive) _controller.repeat();
  }

  @override
  void didUpdateWidget(SineWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 40),
          painter: _SineWavePainter(
            progress: _controller.value,
            isActive: widget.isActive,
          ),
        );
      },
    );
  }
}

class _SineWavePainter extends CustomPainter {
  final double progress;
  final bool isActive;

  _SineWavePainter({required this.progress, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (int wave = 0; wave < 3; wave++) {
      final path = Path();
      final amplitude = size.height * 0.3 * (1 - wave * 0.25);
      final opacity = 1.0 - wave * 0.3;

      paint.color = BilinguiColors.deepPurple.withOpacity(opacity);

      for (double x = 0; x <= size.width; x++) {
        final y = size.height / 2 +
            amplitude *
                math.sin((x / size.width * 4 * math.pi) +
                    progress * 2 * math.pi +
                    wave * 0.5);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SineWavePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isActive != isActive;
}
