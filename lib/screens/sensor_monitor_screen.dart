import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/neon_container.dart';
import '../components/wave_painter.dart';
import '../services/security_state.dart';
import '../theme/app_theme.dart';

class SensorMonitorScreen extends StatefulWidget {
  const SensorMonitorScreen({super.key});

  @override
  State<SensorMonitorScreen> createState() => _SensorMonitorScreenState();
}

class _SensorMonitorScreenState extends State<SensorMonitorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  Timer? _sensorTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _sensorTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final state = context.read<SecurityState>();
      if (!state.isSystemSafe) return;
      state.updateSensors(
        (sin(DateTime.now().millisecondsSinceEpoch / 1000.0) * 0.15 + 0.15).abs(),
        (cos(DateTime.now().millisecondsSinceEpoch / 800.0) * 0.12 + 0.12).abs(),
        (_random.nextDouble() * 0.08).abs(),
      );
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _sensorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityState>(
      builder: (context, state, _) {
        final topPad = MediaQuery.of(context).padding.top + kToolbarHeight + 24;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPad),
              _buildSectionHeader('ACELERÔMETRO'),
              _buildWaveCard(
                color: AppColors.primaryNeon,
                value: state.sensorAccelerometer,
                label: 'Padrão de Movimento',
                noiseLevel: state.isSystemSafe ? 0.0 : 0.8,
              ),
              _buildSectionHeader('GIROSCÓPIO'),
              _buildWaveCard(
                color: AppColors.secondaryNeon,
                value: state.sensorGyroscope,
                label: 'Delta de Orientação',
                frequency: 3.0,
                noiseLevel: state.isSystemSafe ? 0.0 : 0.7,
              ),
              _buildSectionHeader('MAPA DE TOQUE'),
              _buildWaveCard(
                color: state.isSystemSafe ? AppColors.primaryNeon : AppColors.danger,
                value: state.sensorTouch,
                label: 'Pressão de Toque',
                frequency: 4.0,
                amplitude: 20.0,
                noiseLevel: state.isSystemSafe ? 0.0 : 0.95,
              ),
              const SizedBox(height: 16),
              _buildSensorStatus(state),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildWaveCard({
    required Color color,
    required double value,
    required String label,
    double frequency = 2.0,
    double amplitude = 30.0,
    double noiseLevel = 0.0,
  }) {
    return NeonContainer(
      glowColor: color,
      glowIntensity: 0.12,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppFonts.heading(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text.withValues(alpha: 0.7),
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
                  '${(value * 100).toStringAsFixed(1)}%',
                  style: AppFonts.mono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RepaintBoundary(
            child: SizedBox(
              height: 80,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(double.infinity, 80),
                    painter: WavePainter(
                      animationValue: _waveController.value,
                      color: color,
                      amplitude: amplitude,
                      frequency: frequency,
                      noiseLevel: noiseLevel,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorStatus(SecurityState state) {
    return NeonContainer(
      glowColor: state.isSystemSafe ? AppColors.primaryNeon : AppColors.danger,
      glowIntensity: 0.12,
      child: Row(
        children: [
          Icon(
            state.isSystemSafe ? Icons.check_circle : Icons.error,
            color: state.isSystemSafe ? AppColors.primaryNeon : AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              state.isSystemSafe
                  ? 'Todos os sensores normais — nenhuma anomalia detectada'
                  : 'ANOMALIA: Padrões dos sensores indicam injeção remota',
              style: AppFonts.mono(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: state.isSystemSafe ? AppColors.primaryNeon : AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
