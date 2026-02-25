import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/security_state.dart';
import '../theme/app_theme.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityState>(
      builder: (context, state, _) {
        final topPad = MediaQuery.of(context).padding.top + kToolbarHeight + 8;
        return Column(
          children: [
            SizedBox(height: topPad),
            _buildTerminalHeader(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: AppColors.primaryNeon.withValues(alpha: 0.1),
                  ),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(14),
                  itemCount: state.logs.length,
                  itemBuilder: (context, index) {
                    return _buildLogEntry(state.logs[index]);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTerminalHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceLight,
            AppColors.surfaceLight.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.all(
          color: AppColors.primaryNeon.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.danger,
              boxShadow: [
                BoxShadow(
                  color: AppColors.danger.withValues(alpha: 0.4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warning,
              boxShadow: [
                BoxShadow(
                  color: AppColors.warning.withValues(alpha: 0.4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryNeon,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryNeon.withValues(alpha: 0.4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'blockremote — registros.log',
            style: AppFonts.mono(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.terminal,
            color: AppColors.primaryNeon.withValues(alpha: 0.4),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(ThreatEvent event) {
    Color logColor;
    String prefix;
    switch (event.level) {
      case ThreatLevel.critical:
        logColor = AppColors.danger;
        prefix = '!!';
      case ThreatLevel.warning:
        logColor = AppColors.warning;
        prefix = '!>';
      case ThreatLevel.info:
        logColor = AppColors.primaryNeon;
        prefix = '>>';
    }

    final timeStr =
        '${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}:${event.timestamp.second.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: AppFonts.mono(fontSize: 11, color: AppColors.text),
          children: [
            TextSpan(
              text: '[$timeStr] ',
              style: AppFonts.mono(
                fontSize: 11,
                color: AppColors.text.withValues(alpha: 0.3),
              ),
            ),
            TextSpan(
              text: '$prefix ',
              style: AppFonts.mono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: logColor,
              ),
            ),
            TextSpan(
              text: event.message,
              style: AppFonts.mono(
                fontSize: 11,
                color: logColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
