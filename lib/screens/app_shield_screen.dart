import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../components/neon_switch.dart';
import '../components/security_card.dart';
import '../services/security_state.dart';
import '../theme/app_theme.dart';

class AppShieldScreen extends StatelessWidget {
  const AppShieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityState>(
      builder: (context, state, _) {
        final enabledCount = state.protections.where((p) => p.isEnabled).length;
        final totalCount = state.protections.length;

        final topPad = MediaQuery.of(context).padding.top + kToolbarHeight + 8;
        return Column(
          children: [
            SizedBox(height: topPad),
            _buildHeader(enabledCount, totalCount),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                itemCount: state.protections.length,
                itemBuilder: (context, index) {
                  final protection = state.protections[index];
                  return SecurityCard(
                    title: protection.name,
                    subtitle: protection.description,
                    icon: protection.icon,
                    statusColor: protection.isEnabled
                        ? AppColors.primaryNeon
                        : AppColors.text.withValues(alpha: 0.3),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showShieldDetail(context, protection);
                    },
                    trailing: NeonSwitch(
                      value: protection.isEnabled,
                      onChanged: (_) {
                        HapticFeedback.selectionClick();
                        state.toggleProtection(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShieldDetail(BuildContext context, AppProtection protection) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ShieldDetailModal(protection: protection),
    );
  }

  Widget _buildHeader(int enabled, int total) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceLight.withValues(alpha: 0.6),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryNeon.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryNeon.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryNeon.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.verified_user,
              color: AppColors.primaryNeon,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status de Proteção',
                  style: AppFonts.heading(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$enabled/$total',
                      style: AppFonts.mono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryNeon,
                      ),
                    ),
                    Text(
                      ' escudos ativos',
                      style: AppFonts.heading(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildProgressRing(enabled / total),
        ],
      ),
    );
  }

  Widget _buildProgressRing(double progress) {
    return SizedBox(
      width: 44,
      height: 44,
      child: CustomPaint(
        painter: _ProgressRingPainter(progress: progress),
        child: Center(
          child: Text(
            '${(progress * 100).toInt()}%',
            style: AppFonts.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNeon,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShieldDetailModal extends StatelessWidget {
  final AppProtection protection;

  const _ShieldDetailModal({required this.protection});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        protection.isEnabled ? AppColors.primaryNeon : AppColors.text.withValues(alpha: 0.4);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceLight,
            AppColors.surface,
            AppColors.background,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.text.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.2),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Icon(protection.icon, color: statusColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            protection.name,
            style: AppFonts.heading(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              protection.isEnabled ? 'ATIVO' : 'DESATIVADO',
              style: AppFonts.mono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection('DESCRIÇÃO', protection.technicalDetail),
                  const SizedBox(height: 16),
                  _buildDetailRow('Protocolo', protection.protocol),
                  const SizedBox(height: 12),
                  _buildDetailRow('Monitoramento', protection.monitoringStatus),
                  const SizedBox(height: 12),
                  _buildDetailRow('Último Scan', protection.lastScanResult),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.mono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryNeon.withValues(alpha: 0.6),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primaryNeon.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            content,
            style: AppFonts.heading(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.text.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.text.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppFonts.mono(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.text.withValues(alpha: 0.3),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppFonts.mono(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryNeon.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;

  _ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final bgPaint = Paint()
      ..color = AppColors.surfaceLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = AppColors.primaryNeon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      progress * 6.2832,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
