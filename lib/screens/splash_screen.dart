import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final List<_BootLine> _bootLines = [];
  int _currentLine = 0;
  Timer? _lineTimer;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  double _progress = 0.0;

  static const _bootSequence = [
    ('[CORE]', 'Inicializando BlockRemote Engine v2.1.0...'),
    ('[SYS]', 'Carregando módulos de segurança do kernel...'),
    ('[MEM]', 'Verificando integridade de memória — AES-256-GCM...'),
    ('[NET]', 'Estabelecendo túnel criptografado...'),
    ('[CERT]', 'Validando certificados TLS — SHA-384...'),
    ('[SENSOR]', 'Calibrando acelerômetro...'),
    ('[SENSOR]', 'Calibrando giroscópio...'),
    ('[TOUCH]', 'Inicializando modelo ML de padrão de toque...'),
    ('[ML]', 'Carregando pesos de análise de entropia (v2.1)...'),
    ('[SHIELD]', 'Ativando Escudo de Acesso Remoto...'),
    ('[SHIELD]', 'Ativando Guarda Ghost Touch...'),
    ('[SHIELD]', 'Ativando Detector de Overlay...'),
    ('[SHIELD]', 'Ativando Firewall de Rede — motor DPI...'),
    ('[DPI]', 'Carregando feeds de inteligência de ameaças...'),
    ('[SCAN]', 'Executando verificação de integridade do sistema...'),
    ('[SCAN]', 'Escaneando pacotes instalados (0 ameaças)...'),
    ('[A11Y]', 'Enumerando serviços de acessibilidade...'),
    ('[USB]', 'Aplicando bloqueio de depuração USB...'),
    ('[KEY]', 'Ativando camada de criptografia de entrada...'),
    ('[SYS]', 'Todas as camadas de defesa armadas — sistema seguro.'),
    ('[READY]', 'BlockRemote operacional. Bem-vindo de volta.'),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _startBootSequence();
  }

  void _startBootSequence() {
    _lineTimer = Timer.periodic(const Duration(milliseconds: 140), (timer) {
      if (_currentLine >= _bootSequence.length) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) widget.onComplete();
        });
        return;
      }
      setState(() {
        final entry = _bootSequence[_currentLine];
        _bootLines.add(_BootLine(prefix: entry.$1, message: entry.$2));
        _progress = (_currentLine + 1) / _bootSequence.length;
        _currentLine++;
      });
    });
  }

  @override
  void dispose() {
    _lineTimer?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, _) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryNeon.withValues(alpha: _glowAnimation.value * 0.3),
                        blurRadius: 30,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shield,
                    color: AppColors.primaryNeon.withValues(alpha: _glowAnimation.value),
                    size: 48,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'BLOCKREMOTE',
              style: AppFonts.mono(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryNeon,
                letterSpacing: 6.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'SISTEMA DE DEFESA CYBER',
              style: AppFonts.heading(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.text.withValues(alpha: 0.4),
                letterSpacing: 3.0,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryNeon,
                      ),
                      minHeight: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INICIALIZAÇÃO DO SISTEMA',
                        style: AppFonts.mono(
                          fontSize: 9,
                          color: AppColors.text.withValues(alpha: 0.3),
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: AppFonts.mono(
                          fontSize: 9,
                          color: AppColors.primaryNeon,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryNeon.withValues(alpha: 0.1),
                  ),
                ),
                child: ListView.builder(
                  reverse: false,
                  itemCount: _bootLines.length,
                  itemBuilder: (context, index) {
                    final line = _bootLines[index];
                    final isLast = index == _bootLines.length - 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: RichText(
                        text: TextSpan(
                          style: AppFonts.mono(
                            fontSize: 10,
                            color: AppColors.primaryNeon,
                          ),
                          children: [
                            TextSpan(
                              text: '${line.prefix} ',
                              style: AppFonts.mono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isLast
                                    ? AppColors.primaryNeon
                                    : AppColors.primaryNeon.withValues(alpha: 0.5),
                              ),
                            ),
                            TextSpan(
                              text: line.message,
                              style: AppFonts.mono(
                                fontSize: 10,
                                color: isLast
                                    ? AppColors.primaryNeon.withValues(alpha: 0.9)
                                    : AppColors.text.withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BootLine {
  final String prefix;
  final String message;
  _BootLine({required this.prefix, required this.message});
}
