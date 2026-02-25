import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';
import '../widgets/animated_brain_logo.dart';
import '../widgets/cyber_loading.dart';
import '../widgets/gradient_button.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback? onLogin;
  const AuthScreen({super.key, this.onLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted && widget.onLogin != null) {
        widget.onLogin!();
      }
    });
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _animController.reset();
      _animController.forward();
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: BilinguiColors.deepPurple.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: BilinguiColors.deepPurple.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: AppFonts.poppins(
          color: BilinguiColors.textPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppFonts.poppins(
            color: BilinguiColors.deepPurple.withOpacity(0.7),
            fontSize: 14,
          ),
          hintStyle: AppFonts.poppins(
            color: BilinguiColors.textSecondary.withOpacity(0.5),
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: BilinguiColors.deepPurple.withOpacity(0.6)),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: BilinguiColors.deepPurple, width: 1.5),
          ),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: BilinguiColors.authGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                  const AnimatedBrainLogo(size: 100),
                  const SizedBox(height: 20),
                  Text(
                    'Bilingui-AI',
                    style: AppFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: BilinguiColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin ? 'Bem-vindo de volta!' : 'Crie sua conta',
                    style: AppFonts.poppins(
                      fontSize: 16,
                      color: BilinguiColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (!_isLogin) ...[
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nome Completo',
                      hint: 'Digite seu nome',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    hint: 'seu@email.com',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    hint: 'Digite sua senha',
                    icon: Icons.lock_outline,
                    obscure: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: BilinguiColors.deepPurple.withOpacity(0.4),
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    text: _isLogin ? 'Entrar' : 'Criar Conta',
                    onPressed: _handleAuth,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? 'Não tem uma conta? '
                            : 'Já tem uma conta? ',
                        style: AppFonts.poppins(
                          color: BilinguiColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleMode,
                        child: Text(
                          _isLogin ? 'Cadastrar' : 'Entrar',
                          style: AppFonts.poppins(
                            color: BilinguiColors.deepPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
          if (_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFE8D5F5).withOpacity(0.92),
              child: const Center(
                child: CyberLoading(
                  size: 100,
                  message: 'ENTRANDO',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
