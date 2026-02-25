import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/bilingui_theme.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BilinguiApp()));
}

class BilinguiApp extends StatelessWidget {
  const BilinguiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bilingui-AI',
      debugShowCheckedModeBanner: false,
      theme: BilinguiTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
