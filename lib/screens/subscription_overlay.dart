import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/security_state.dart';
import '../theme/app_theme.dart';

class SubscriptionOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const SubscriptionOverlay({super.key, required this.onDismiss});

  @override
  State<SubscriptionOverlay> createState() => _SubscriptionOverlayState();
}

class _SubscriptionOverlayState extends State<SubscriptionOverlay>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _glowPulseController;
  late AnimationController _ctaGlowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowPulseAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _glowPulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    _glowPulseAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowPulseController, curve: Curves.easeInOut),
    );

    _ctaGlowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _entryController.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _glowPulseController.dispose();
    _ctaGlowController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _entryController.reverse().then((_) => widget.onDismiss());
  }

  void _activateSubscription() {
    HapticFeedback.heavyImpact();
    context.read<SecurityState>().activateSubscription();
    _entryController.reverse().then((_) => widget.onDismiss());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black),
            ),

            Positioned.fill(
              child: Opacity(
                opacity: 0.08 * _fadeAnimation.value,
                child: CustomPaint(
                  painter: _CircuitTexturePainter(),
                  size: Size.infinite,
                ),
              ),
            ),

            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 3 * _fadeAnimation.value,
                  sigmaY: 3 * _fadeAnimation.value,
                ),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4 * _fadeAnimation.value),
                ),
              ),
            ),

            GestureDetector(
              onTap: _dismiss,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),

            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildVaultCard(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVaultCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.88).clamp(0.0, 380.0);

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryNeon.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNeon.withValues(alpha: 0.04),
            blurRadius: 60,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLockIcon(),
                const SizedBox(height: 28),
                _buildHeadline(),
                const SizedBox(height: 10),
                _buildSubheadline(),
                const SizedBox(height: 32),
                _buildPrice(),
                const SizedBox(height: 32),
                _buildFeatures(),
                const SizedBox(height: 36),
                _buildCTAButton(),
                const SizedBox(height: 16),
                _buildRestoreButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockIcon() {
    return AnimatedBuilder(
      animation: _glowPulseAnimation,
      builder: (context, _) {
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: AppColors.primaryNeon.withValues(
                alpha: 0.15 + 0.15 * _glowPulseAnimation.value,
              ),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNeon.withValues(
                  alpha: 0.08 * _glowPulseAnimation.value,
                ),
                blurRadius: 30,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primaryNeon.withValues(alpha: 0.8),
            size: 24,
          ),
        );
      },
    );
  }

  Widget _buildHeadline() {
    return Text(
      'Blindagem Total',
      textAlign: TextAlign.center,
      style: AppFonts.heading(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        letterSpacing: -0.3,
      ).copyWith(height: 1.3),
    );
  }

  Widget _buildSubheadline() {
    return Text(
      'Desbloqueie todas as camadas de\nproteção para seu dispositivo',
      textAlign: TextAlign.center,
      style: AppFonts.heading(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.text.withValues(alpha: 0.45),
        letterSpacing: 0.1,
      ).copyWith(height: 1.6),
    );
  }

  Widget _buildPrice() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'R\$',
          style: AppFonts.mono(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryNeon.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '9,90',
          style: AppFonts.mono(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryNeon,
          ).copyWith(
            height: 1.0,
            shadows: [
              Shadow(
                color: AppColors.primaryNeon.withValues(alpha: 0.4),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 2),
          child: Text(
            '/mês',
            style: AppFonts.mono(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.text.withValues(alpha: 0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    final features = [
      'Proteção em tempo real 24/7',
      'Kill switch instantâneo',
      'Blindagem ilimitada de apps',
      'Logs de auditoria completos',
    ];

    return Column(
      children: features
          .map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: AppColors.primaryNeon.withValues(alpha: 0.6),
                      size: 16,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        f,
                        style: AppFonts.heading(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text.withValues(alpha: 0.7),
                          letterSpacing: 0.1,
                        ).copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCTAButton() {
    return AnimatedBuilder(
      animation: _ctaGlowController,
      builder: (context, _) {
        final glowValue = _ctaGlowController.value;
        return Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNeon.withValues(
                  alpha: 0.12 + 0.08 * glowValue,
                ),
                blurRadius: 24,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _activateSubscription,
              borderRadius: BorderRadius.circular(14),
              splashColor: AppColors.primaryNeon.withValues(alpha: 0.1),
              highlightColor: AppColors.primaryNeon.withValues(alpha: 0.05),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primaryNeon.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    'ATIVAR BLINDAGEM',
                    style: AppFonts.heading(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNeon,
                      letterSpacing: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRestoreButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _dismiss();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Restaurar compra',
          style: AppFonts.heading(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.text.withValues(alpha: 0.25),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _CircuitTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final gridSpacing = 40.0;
    final cols = (size.width / gridSpacing).ceil() + 1;
    final rows = (size.height / gridSpacing).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final x = c * gridSpacing + rng.nextDouble() * 8 - 4;
        final y = r * gridSpacing + rng.nextDouble() * 8 - 4;

        if (rng.nextDouble() < 0.35) {
          canvas.drawCircle(Offset(x, y), 1.5, nodePaint);
        }

        if (rng.nextDouble() < 0.3 && c < cols - 1) {
          final endX = (c + 1) * gridSpacing + rng.nextDouble() * 8 - 4;
          final endY = y + (rng.nextDouble() * 16 - 8);
          if (rng.nextBool()) {
            final midX = x + (endX - x) * 0.5;
            final path = Path()
              ..moveTo(x, y)
              ..lineTo(midX, y)
              ..lineTo(midX, endY)
              ..lineTo(endX, endY);
            canvas.drawPath(path, linePaint);
          } else {
            canvas.drawLine(Offset(x, y), Offset(endX, endY), linePaint);
          }
        }

        if (rng.nextDouble() < 0.2 && r < rows - 1) {
          final endX = x + (rng.nextDouble() * 12 - 6);
          final endY = (r + 1) * gridSpacing + rng.nextDouble() * 8 - 4;
          canvas.drawLine(Offset(x, y), Offset(endX, endY), linePaint);
        }

        if (rng.nextDouble() < 0.08) {
          final rectSize = 4.0 + rng.nextDouble() * 4;
          canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: rectSize, height: rectSize),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
