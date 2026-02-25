import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../components/cyber_button.dart';
import '../components/neon_container.dart';
import '../services/security_state.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityState>(
      builder: (context, state, _) {
        final isSafe = state.isSystemSafe;
        final statusColor = isSafe ? AppColors.primaryNeon : AppColors.danger;

        final topPad = MediaQuery.of(context).padding.top + kToolbarHeight + 32;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: topPad),
              _buildStatusOrb(isSafe, statusColor),
              const SizedBox(height: 24),
              _buildStatusText(isSafe, statusColor),
              const SizedBox(height: 24),
              _buildLiveStats(state),
              const SizedBox(height: 12),
              _buildMetricsRow(state),
              const SizedBox(height: 20),
              _buildActionButtons(state, isSafe),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOrb(bool isSafe, Color statusColor) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _rotationController, _scanAnimation]),
        builder: (context, _) {
          return SizedBox(
            width: 240,
            height: 240,
            child: CustomPaint(
              painter: _StatusOrbPainter(
                pulseValue: _pulseAnimation.value,
                rotationValue: _rotationController.value,
                scanValue: _scanAnimation.value,
                color: statusColor,
                isSafe: isSafe,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSafe ? Icons.shield : Icons.warning_amber_rounded,
                      color: statusColor,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSafe ? 'SEGURO' : 'AMEAÇA',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusText(bool isSafe, Color statusColor) {
    return Column(
      children: [
        Text(
          isSafe ? 'Sistema Protegido' : 'Ameaça Detectada!',
          style: AppFonts.heading(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: statusColor,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isSafe
              ? 'Todas as camadas de defesa estão ativas e monitorando'
              : 'Tentativa de acesso remoto bloqueada — verifique os registros',
          style: AppFonts.heading(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.text.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLiveStats(SecurityState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: NeonContainer(
        glowColor: state.isSystemSafe ? AppColors.primaryNeon : AppColors.danger,
        glowIntensity: 0.12,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            Expanded(
              child: _LiveCounter(
                label: 'REQUISIÇÕES',
                value: _formatNumber(state.requestsAnalyzed),
                color: AppColors.primaryNeon,
              ),
            ),
            Container(
              width: 1,
              height: 36,
              color: AppColors.text.withValues(alpha: 0.08),
            ),
            Expanded(
              child: _LiveCounter(
                label: 'INTEG. MEMÓRIA',
                value: '${state.memoryIntegrity.toStringAsFixed(1)}%',
                color: AppColors.secondaryNeon,
              ),
            ),
            Container(
              width: 1,
              height: 36,
              color: AppColors.text.withValues(alpha: 0.08),
            ),
            Expanded(
              child: _LiveCounter(
                label: 'PACOTES',
                value: _formatNumber(state.packetsScanned),
                color: AppColors.primaryNeon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  Widget _buildMetricsRow(SecurityState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _MetricTile(
              label: 'AMEAÇAS\nBLOQUEADAS',
              value: state.isSystemSafe ? '0' : '3',
              color: state.isSystemSafe ? AppColors.primaryNeon : AppColors.danger,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MetricTile(
              label: 'ESCUDOS\nATIVOS',
              value: '${state.protections.where((p) => p.isEnabled).length}',
              color: AppColors.secondaryNeon,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MetricTile(
              label: 'HORAS\nATIVO',
              value: '24',
              color: AppColors.primaryNeon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(SecurityState state, bool isSafe) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CyberButton(
        label: isSafe ? 'SIMULAR AMEAÇA' : 'NEUTRALIZAR AMEAÇA',
        icon: isSafe ? Icons.bug_report_outlined : Icons.security,
        color: isSafe ? AppColors.warning : AppColors.primaryNeon,
        heavyHaptic: true,
        onPressed: () {
          if (isSafe) {
            HapticFeedback.heavyImpact();
            state.simulateThreat();
          } else {
            HapticFeedback.mediumImpact();
            state.clearThreat();
          }
        },
      ),
    );
  }
}

class _LiveCounter extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _LiveCounter({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppFonts.mono(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppFonts.heading(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: AppColors.text.withValues(alpha: 0.35),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return NeonContainer(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      glowColor: color,
      glowIntensity: 0.15,
      child: Column(
        children: [
          Text(
            value,
            style: AppFonts.mono(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppFonts.heading(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.text.withValues(alpha: 0.4),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusOrbPainter extends CustomPainter {
  final double pulseValue;
  final double rotationValue;
  final double scanValue;
  final Color color;
  final bool isSafe;

  _StatusOrbPainter({
    required this.pulseValue,
    required this.rotationValue,
    required this.scanValue,
    required this.color,
    required this.isSafe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 3; i >= 0; i--) {
      final radius = maxRadius - (i * 8) + (pulseValue * 4);
      final opacity = 0.05 + (i * 0.03);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, paint);
    }

    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.4 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, maxRadius - 8, ringPaint);

    final innerRingPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, maxRadius - 24, innerRingPaint);

    final arcPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationValue * 2 * pi);
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: maxRadius - 16),
      0,
      pi / 2,
      false,
      arcPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: maxRadius - 16),
      pi,
      pi / 3,
      false,
      arcPaint,
    );
    canvas.restore();

    if (isSafe) {
      final scanAngle = scanValue * 2 * pi;
      final scanPaint = Paint()
        ..shader = SweepGradient(
          startAngle: scanAngle - 0.5,
          endAngle: scanAngle,
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.15),
          ],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius));
      canvas.drawCircle(center, maxRadius - 24, scanPaint);
    }

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi;
      final tickStart = center +
          Offset(cos(angle) * (maxRadius - 6), sin(angle) * (maxRadius - 6));
      final tickEnd = center +
          Offset(cos(angle) * (maxRadius - 2), sin(angle) * (maxRadius - 2));
      final tickPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(tickStart, tickEnd, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StatusOrbPainter oldDelegate) => true;
}
