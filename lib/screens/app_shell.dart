import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';
import '../widgets/animated_brain_logo.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  String _screen = 'splash';
  Timer? _navTimer;
  Timer? _titleTimer;

  late AnimationController _fadeController;
  late AnimationController _titleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _titleTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) _titleController.forward();
    });
    _navTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted) setState(() => _screen = 'auth');
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _titleTimer?.cancel();
    _fadeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _goToHome() {
    if (mounted) setState(() => _screen = 'home');
  }

  @override
  Widget build(BuildContext context) {
    if (_screen == 'home') {
      return const HomeScreen();
    }
    if (_screen == 'auth') {
      return AuthScreen(onLogin: _goToHome);
    }
    return _buildSplash();
  }

  Widget _buildSplash() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BilinguiColors.darkGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: const AnimatedBrainLogo(size: 140),
              ),
              const SizedBox(height: 32),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Bilingui-AI',
                        style: AppFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: BilinguiColors.softLilac,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Learn. Speak. Master.',
                        style: AppFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
