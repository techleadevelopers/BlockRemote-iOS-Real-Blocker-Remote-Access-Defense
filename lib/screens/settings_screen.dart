import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../components/neon_container.dart';
import '../components/neon_switch.dart';
import '../services/security_state.dart';
import '../theme/app_theme.dart';
import 'subscription_overlay.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityState>(
      builder: (context, state, _) {
        final topPad = MediaQuery.of(context).padding.top + kToolbarHeight + 24;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPad),
              _buildSectionTitle('SENSIBILIDADE DE DETECÇÃO'),
              _buildSliderCard(
                label: 'Detecção Ghost Hand',
                value: state.ghostHandSensitivity,
                onChanged: state.setGhostHandSensitivity,
                icon: Icons.touch_app_outlined,
                description: 'Sensibilidade para detectar padrões de toque fantasma',
              ),
              _buildSliderCard(
                label: 'Limiar de Toque Remoto',
                value: state.remoteTouchThreshold,
                onChanged: state.setRemoteTouchThreshold,
                icon: Icons.screen_lock_portrait_outlined,
                color: AppColors.secondaryNeon,
                description: 'Confiança mínima para sinalizar um toque remoto',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('PROTEÇÃO'),
              _buildToggleCard(
                label: 'Bloqueio Automático',
                description: 'Bloquear automaticamente tentativas de acesso remoto',
                icon: Icons.block_outlined,
                value: state.autoBlock,
                onChanged: state.setAutoBlock,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('NOTIFICAÇÕES'),
              _buildToggleCard(
                label: 'Notificações Push',
                description: 'Receber alertas de detecção de ameaças',
                icon: Icons.notifications_outlined,
                value: state.notifications,
                onChanged: state.setNotifications,
              ),
              _buildToggleCard(
                label: 'Feedback Háptico',
                description: 'Vibrar ao detectar ameaça',
                icon: Icons.vibration_outlined,
                value: state.hapticFeedback,
                onChanged: state.setHapticFeedback,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('FATURAMENTO'),
              _buildBillingCard(context, state),
              const SizedBox(height: 16),
              _buildSectionTitle('SISTEMA'),
              _buildInfoCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primaryNeon,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryNeon.withValues(alpha: 0.4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppFonts.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNeon,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required IconData icon,
    required String description,
    Color color = AppColors.primaryNeon,
  }) {
    return NeonContainer(
      glowColor: color,
      glowIntensity: 0.08,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppFonts.heading(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: AppFonts.mono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: AppFonts.heading(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.text.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.12),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.12),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value,
              min: 0.0,
              max: 1.0,
              onChanged: (v) {
                HapticFeedback.selectionClick();
                onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String label,
    required String description,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return NeonContainer(
      glowColor: value ? AppColors.primaryNeon : Colors.transparent,
      glowIntensity: value ? 0.08 : 0,
      child: Row(
        children: [
          Icon(
            icon,
            color: value
                ? AppColors.primaryNeon
                : AppColors.text.withValues(alpha: 0.4),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppFonts.heading(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppFonts.heading(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          NeonSwitch(
            value: value,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBillingCard(BuildContext context, SecurityState state) {
    final isSubscribed = state.isSubscribed;
    return NeonContainer(
      glowColor: isSubscribed ? AppColors.primaryNeon : AppColors.secondaryNeon,
      glowIntensity: 0.08,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isSubscribed ? AppColors.primaryNeon : AppColors.secondaryNeon)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (isSubscribed ? AppColors.primaryNeon : AppColors.secondaryNeon)
                        .withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(
                  Icons.credit_card,
                  color: isSubscribed ? AppColors.primaryNeon : AppColors.secondaryNeon,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Plano Atual',
                          style: AppFonts.heading(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (isSubscribed ? AppColors.primaryNeon : AppColors.text)
                                .withValues(alpha: isSubscribed ? 0.12 : 0.06),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: (isSubscribed ? AppColors.primaryNeon : AppColors.text)
                                  .withValues(alpha: isSubscribed ? 0.4 : 0.1),
                            ),
                          ),
                          child: Text(
                            isSubscribed ? 'PREMIUM' : 'FREE',
                            style: AppFonts.mono(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isSubscribed
                                  ? AppColors.primaryNeon
                                  : AppColors.text.withValues(alpha: 0.5),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSubscribed ? 'R\$ 9,90/mês — Blindagem Total ativa' : 'Recursos limitados',
                      style: AppFonts.heading(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.text.withValues(alpha: 0.06), height: 1),
          const SizedBox(height: 4),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                if (!isSubscribed) {
                  _showPaywall(context);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      isSubscribed ? Icons.settings_outlined : Icons.rocket_launch_outlined,
                      color: isSubscribed
                          ? AppColors.text.withValues(alpha: 0.5)
                          : AppColors.secondaryNeon,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isSubscribed ? 'Gerenciar Assinatura' : 'Assinar Premium',
                        style: AppFonts.heading(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSubscribed
                              ? AppColors.text.withValues(alpha: 0.6)
                              : AppColors.secondaryNeon,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.text.withValues(alpha: 0.3),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaywall(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Paywall',
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) {
        return SubscriptionOverlay(
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return NeonContainer(
      glowColor: AppColors.primaryNeon,
      glowIntensity: 0.05,
      child: Column(
        children: [
          _buildInfoRow('Versão', '2.1.0'),
          Divider(color: AppColors.text.withValues(alpha: 0.06), height: 20),
          _buildInfoRow('Motor', 'BlockRemote Core'),
          Divider(color: AppColors.text.withValues(alpha: 0.06), height: 20),
          _buildInfoRow('Criptografia', 'AES-256-GCM'),
          Divider(color: AppColors.text.withValues(alpha: 0.06), height: 20),
          _buildInfoRow('Última Atualização', '2026-02-25'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFonts.heading(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.text.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: AppFonts.mono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryNeon,
          ),
        ),
      ],
    );
  }
}
