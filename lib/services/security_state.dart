import 'dart:async';
import 'package:flutter/material.dart';

class ThreatEvent {
  final String message;
  final DateTime timestamp;
  final ThreatLevel level;

  ThreatEvent({
    required this.message,
    required this.timestamp,
    required this.level,
  });
}

enum ThreatLevel { info, warning, critical }

class AppProtection {
  final String name;
  final String description;
  final IconData icon;
  final String technicalDetail;
  final String protocol;
  final String monitoringStatus;
  final String lastScanResult;
  bool isEnabled;

  AppProtection({
    required this.name,
    required this.description,
    required this.icon,
    required this.technicalDetail,
    required this.protocol,
    required this.monitoringStatus,
    required this.lastScanResult,
    this.isEnabled = true,
  });
}

class SecurityState extends ChangeNotifier {
  bool _isSystemSafe = true;
  bool _isInitialized = false;
  bool _isSubscribed = false;
  double _sensorAccelerometer = 0.0;
  double _sensorGyroscope = 0.0;
  double _sensorTouch = 0.0;
  double _ghostHandSensitivity = 0.75;
  double _remoteTouchThreshold = 0.60;
  bool _autoBlock = true;
  bool _notifications = true;
  bool _hapticFeedback = true;

  int _requestsAnalyzed = 148392;
  double _memoryIntegrity = 99.7;
  int _packetsScanned = 52417;
  Timer? _liveCounterTimer;

  SecurityState() {
    _startLiveCounters();
  }

  void _startLiveCounters() {
    _liveCounterTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (_isSystemSafe) {
        _requestsAnalyzed += 3 + DateTime.now().millisecond % 7;
        _packetsScanned += 1 + DateTime.now().millisecond % 4;
        _memoryIntegrity = 99.5 + (DateTime.now().millisecond % 5) * 0.1;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _liveCounterTimer?.cancel();
    super.dispose();
  }

  final List<ThreatEvent> _logs = [
    ThreatEvent(
      message: '[SYS] BlockRemote v2.1.0 inicializado',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      level: ThreatLevel.info,
    ),
    ThreatEvent(
      message: '[SCAN] Varredura completa concluída — sem ameaças',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      level: ThreatLevel.info,
    ),
    ThreatEvent(
      message: '[NET] Túnel seguro estabelecido (AES-256)',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      level: ThreatLevel.info,
    ),
    ThreatEvent(
      message: '[SENSOR] Padrão de toque calibrado',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      level: ThreatLevel.info,
    ),
    ThreatEvent(
      message: '[SHIELD] Camada de proteção de apps ativa',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      level: ThreatLevel.info,
    ),
  ];

  final List<AppProtection> _protections = [
    AppProtection(
      name: 'Escudo de Acesso Remoto',
      description: 'Bloqueia ADB e espelhamento não autorizado',
      icon: Icons.shield_outlined,
      technicalDetail: 'Interceptação ativa de listener ADB via hooks de nível kernel. Todas as conexões USB debug bridge são monitoradas e encerradas se não autorizadas. Protocolos de espelhamento (Miracast, AirPlay spoof) são filtrados na camada de transporte.',
      protocol: 'ADB-INTERCEPT v3.2 / HDCP-MONITOR',
      monitoringStatus: 'Tempo real | Varredura ativa 24/7',
      lastScanResult: 'Limpo — 0 conexões não autorizadas nas últimas 24h',
    ),
    AppProtection(
      name: 'Guarda Ghost Touch',
      description: 'Detecta injeção de toque fantasma',
      icon: Icons.touch_app_outlined,
      technicalDetail: 'Modelo de machine learning analisa velocidade de eventos de toque, curvas de pressão e entropia de coordenadas para distinguir entrada humana de eventos sintéticos injetados. Recalibração a cada 60 segundos.',
      protocol: 'TOUCH-ML v2.1 / ENTROPY-SCAN',
      monitoringStatus: 'Tempo real | Modelo ML ativo',
      lastScanResult: 'Baseline estável — variância de entropia < 0.02',
    ),
    AppProtection(
      name: 'Detector de Overlay',
      description: 'Previne overlays maliciosos na tela',
      icon: Icons.layers_outlined,
      technicalDetail: 'Monitora WindowManager para permissões de overlay não autorizadas. Detecta camadas TYPE_APPLICATION_OVERLAY e TYPE_SYSTEM_ALERT de pacotes não permitidos. Kill-switch instantâneo na detecção.',
      protocol: 'OVERLAY-WATCH v1.8 / WM-SCAN',
      monitoringStatus: 'Tempo real | Monitoramento de janelas',
      lastScanResult: 'Limpo — nenhum overlay não autorizado detectado',
    ),
    AppProtection(
      name: 'Bloqueio USB Debug',
      description: 'Desativa depuração USB quando ativo',
      icon: Icons.usb_outlined,
      technicalDetail: 'Força depuração USB para estado OFF via Settings.Global. Monitora mudanças de estado e reforça bloqueio em 50ms de qualquer tentativa não autorizada.',
      protocol: 'USB-LOCK v2.0 / SETTINGS-GUARD',
      monitoringStatus: 'Ativo | Aplicação de estado habilitada',
      lastScanResult: 'Bloqueado — depuração USB desativada',
    ),
    AppProtection(
      name: 'Bloqueio de Captura',
      description: 'Previne capturas de tela não autorizadas',
      icon: Icons.screenshot_monitor_outlined,
      technicalDetail: 'FLAG_SECURE aplicado em todas as janelas sensíveis. Acesso à API MediaProjection é interceptado. Detecção de screenshot via FileObserver no diretório DCIM/Screenshots com alerta instantâneo.',
      protocol: 'CAPTURE-BLOCK v1.5 / MEDIA-INTERCEPT',
      monitoringStatus: 'Ativo | FLAG_SECURE aplicado',
      lastScanResult: 'Seguro — 0 tentativas de captura bloqueadas',
    ),
    AppProtection(
      name: 'Guarda de Acessibilidade',
      description: 'Monitora abuso de serviços de acessibilidade',
      icon: Icons.accessibility_new_outlined,
      technicalDetail: 'Enumera AccessibilityServices ativos e cruza com assinaturas de pacotes maliciosos conhecidos. Monitora serviços que solicitam FLAG_REQUEST_FILTER_KEY_EVENTS ou FLAG_RETRIEVE_INTERACTIVE_WINDOWS.',
      protocol: 'A11Y-GUARD v2.3 / SERVICE-ENUM',
      monitoringStatus: 'Tempo real | Enumeração de serviços ativa',
      lastScanResult: 'Limpo — todos os serviços verificados como confiáveis',
    ),
    AppProtection(
      name: 'Firewall de Rede',
      description: 'Filtra conexões de saída suspeitas',
      icon: Icons.wifi_lock_outlined,
      technicalDetail: 'Inspeção profunda de pacotes em todas as conexões TCP/UDP de saída. Pontuação de reputação de IP via feeds de inteligência. Aplicação de DNS-over-HTTPS para prevenir sequestro de DNS. Encerramento automático de conexões com padrões de servidor C2.',
      protocol: 'NET-WALL v3.0 / DPI-ENGINE / DOH',
      monitoringStatus: 'Tempo real | DPI ativo em todas as interfaces',
      lastScanResult: 'Filtrado — 12 IPs suspeitos bloqueados hoje',
    ),
    AppProtection(
      name: 'Escudo Anti-Keylogger',
      description: 'Protege entrada do teclado contra captura',
      icon: Icons.keyboard_outlined,
      technicalDetail: 'Camada de criptografia entre IME e aplicação. Randomização de timing de teclas para derrotar análise temporal. Proxy InputConnection previne que keyloggers baseados em IME capturem eventos de entrada.',
      protocol: 'KEY-SHIELD v1.9 / IME-ENCRYPT',
      monitoringStatus: 'Ativo | Criptografia de entrada habilitada',
      lastScanResult: 'Seguro — integridade do IME verificada',
    ),
  ];

  bool get isSystemSafe => _isSystemSafe;
  bool get isInitialized => _isInitialized;
  bool get isSubscribed => _isSubscribed;
  double get sensorAccelerometer => _sensorAccelerometer;
  double get sensorGyroscope => _sensorGyroscope;
  double get sensorTouch => _sensorTouch;
  double get ghostHandSensitivity => _ghostHandSensitivity;
  double get remoteTouchThreshold => _remoteTouchThreshold;
  bool get autoBlock => _autoBlock;
  bool get notifications => _notifications;
  bool get hapticFeedback => _hapticFeedback;
  int get requestsAnalyzed => _requestsAnalyzed;
  double get memoryIntegrity => _memoryIntegrity;
  int get packetsScanned => _packetsScanned;
  List<ThreatEvent> get logs => List.unmodifiable(_logs);
  List<AppProtection> get protections => _protections;

  void completeInitialization() {
    _isInitialized = true;
    notifyListeners();
  }

  void simulateThreat() {
    _isSystemSafe = false;
    _sensorAccelerometer = 0.92;
    _sensorGyroscope = 0.87;
    _sensorTouch = 0.95;
    _logs.insert(
      0,
      ThreatEvent(
        message: '[ALERTA] Ataque Ghost Hand detectado — injeção de toque remoto!',
        timestamp: DateTime.now(),
        level: ThreatLevel.critical,
      ),
    );
    _logs.insert(
      0,
      ThreatEvent(
        message: '[BLOCK] Tentativa de acesso remoto não autorizado bloqueada',
        timestamp: DateTime.now(),
        level: ThreatLevel.warning,
      ),
    );
    _logs.insert(
      0,
      ThreatEvent(
        message: '[NET] Conexão suspeita para 45.33.xx.xx encerrada',
        timestamp: DateTime.now(),
        level: ThreatLevel.critical,
      ),
    );
    notifyListeners();
  }

  void clearThreat() {
    _isSystemSafe = true;
    _sensorAccelerometer = 0.0;
    _sensorGyroscope = 0.0;
    _sensorTouch = 0.0;
    _logs.insert(
      0,
      ThreatEvent(
        message: '[SYS] Ameaça neutralizada — sistema restaurado',
        timestamp: DateTime.now(),
        level: ThreatLevel.info,
      ),
    );
    notifyListeners();
  }

  void toggleProtection(int index) {
    _protections[index].isEnabled = !_protections[index].isEnabled;
    final p = _protections[index];
    _logs.insert(
      0,
      ThreatEvent(
        message: '[SHIELD] ${p.name} ${p.isEnabled ? "ativado" : "desativado"}',
        timestamp: DateTime.now(),
        level: p.isEnabled ? ThreatLevel.info : ThreatLevel.warning,
      ),
    );
    notifyListeners();
  }

  void setGhostHandSensitivity(double value) {
    _ghostHandSensitivity = value;
    notifyListeners();
  }

  void setRemoteTouchThreshold(double value) {
    _remoteTouchThreshold = value;
    notifyListeners();
  }

  void setAutoBlock(bool value) {
    _autoBlock = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notifications = value;
    notifyListeners();
  }

  void setHapticFeedback(bool value) {
    _hapticFeedback = value;
    notifyListeners();
  }

  void updateSensors(double accel, double gyro, double touch) {
    _sensorAccelerometer = accel;
    _sensorGyroscope = gyro;
    _sensorTouch = touch;
    notifyListeners();
  }

  void activateSubscription() {
    _isSubscribed = true;
    _logs.insert(
      0,
      ThreatEvent(
        message: '[SUB] Assinatura Premium ativada — proteção total habilitada',
        timestamp: DateTime.now(),
        level: ThreatLevel.info,
      ),
    );
    notifyListeners();
  }
}
