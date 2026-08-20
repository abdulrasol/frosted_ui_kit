import 'package:flutter/material.dart';
import 'src/catalog_home_screen.dart';

void main() {
  runApp(const MySandboxApp());
}

/// Playground application for testing and extending [frosted_ui_kit] components.
class MySandboxApp extends StatefulWidget {
  const MySandboxApp({super.key});

  static MySandboxAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MySandboxAppState>()!;

  @override
  State<MySandboxApp> createState() => MySandboxAppState();
}

class MySandboxAppState extends State<MySandboxApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frosted UI Kit Sandbox',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1F1C2C),
      ),
      home: const CatalogHomeScreen(),
    );
  }
}
