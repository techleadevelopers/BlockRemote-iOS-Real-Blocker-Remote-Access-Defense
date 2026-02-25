import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/security_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/sensor_monitor_screen.dart';
import 'screens/app_shield_screen.dart';
import 'screens/audit_logs_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/subscription_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlockRemoteApp());
}

class BlockRemoteApp extends StatelessWidget {
  const BlockRemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SecurityState(),
      child: MaterialApp(
        title: 'BlockRemote',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AppEntry(),
      ),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onComplete: () {
          setState(() => _showSplash = false);
          context.read<SecurityState>().completeInitialization();
        },
      );
    }
    return const MainShell();
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _showPaywall = false;
  late PageController _pageController;

  static const _titles = [
    'BLOCKREMOTE',
    'MONITOR DE SENSORES',
    'BLINDAGEM',
    'REGISTROS',
    'CONFIGURAÇÕES',
  ];

  static const _premiumTabs = {2, 3};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    HapticFeedback.lightImpact();
    final state = context.read<SecurityState>();
    if (_premiumTabs.contains(index) && !state.isSubscribed) {
      setState(() => _showPaywall = true);
      return;
    }
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _dismissPaywall() {
    setState(() => _showPaywall = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityState>(
      builder: (context, state, _) {
        final dangerMode = !state.isSystemSafe;
        final accentColor = dangerMode ? AppColors.danger : AppColors.primaryNeon;

        return Stack(
          children: [
            Scaffold(
          backgroundColor: AppColors.background,
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.surface.withValues(alpha: 0.8),
                        AppColors.surface.withValues(alpha: 0.5),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: accentColor.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: 56,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _StatusDot(color: accentColor),
                            const SizedBox(width: 10),
                            Text(
                              _titles[_currentIndex],
                              style: AppFonts.mono(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                                letterSpacing: 2.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              DashboardScreen(),
              SensorMonitorScreen(),
              AppShieldScreen(),
              AuditLogsScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surface.withValues(alpha: 0.5),
                      AppColors.surface.withValues(alpha: 0.85),
                    ],
                  ),
                  border: Border(
                    top: BorderSide(
                      color: accentColor.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: List.generate(5, (i) {
                        final isSelected = _currentIndex == i;
                        final icons = [
                          Icons.dashboard_outlined,
                          Icons.sensors_outlined,
                          Icons.security_outlined,
                          Icons.terminal_outlined,
                          Icons.tune_outlined,
                        ];
                        final activeIcons = [
                          Icons.dashboard,
                          Icons.sensors,
                          Icons.security,
                          Icons.terminal,
                          Icons.tune,
                        ];
                        final labels = [
                          'INÍCIO',
                          'SENSORES',
                          'BLINDAGEM',
                          'REGISTROS',
                          'CONFIG',
                        ];

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _onTabTapped(i),
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    decoration: isSelected
                                        ? BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: accentColor.withValues(alpha: 0.4),
                                                blurRadius: 12,
                                              ),
                                            ],
                                          )
                                        : null,
                                    child: Icon(
                                      isSelected ? activeIcons[i] : icons[i],
                                      color: isSelected
                                          ? accentColor
                                          : AppColors.text.withValues(alpha: 0.2),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    labels[i],
                                    style: AppFonts.mono(
                                      fontSize: 8,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? accentColor
                                          : AppColors.text.withValues(alpha: 0.2),
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
            if (_showPaywall)
              SubscriptionOverlay(onDismiss: _dismissPaywall),
          ],
        );
      },
    );
  }
}

class _StatusDot extends StatefulWidget {
  final Color color;
  const _StatusDot({required this.color});

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _animation.value),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
