import 'package:material_ui/material_ui.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

import 'src/catalog_home_screen.dart';

void main() {
  runApp(const MySandboxApp());
}

/// Playground application for testing and extending [frosted_ui_kit] components.
class MySandboxApp extends StatefulWidget {
  const MySandboxApp({super.key, this.performancePreset});

  final String? performancePreset;

  static MySandboxAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MySandboxAppState>()!;

  @override
  State<MySandboxApp> createState() => MySandboxAppState();
}

class MySandboxAppState extends State<MySandboxApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _rightToLeft = false;
  bool _largeText = false;
  FrostedPerformanceData _performance = FrostedPerformance.balanced;

  @override
  void initState() {
    super.initState();
    _performance = switch (widget.performancePreset) {
      'full' => FrostedPerformance.full,
      'android' => FrostedPerformance.android,
      'lite' => FrostedPerformance.lite,
      _ => FrostedPerformance.balanced,
    };
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleDirection() => setState(() => _rightToLeft = !_rightToLeft);

  void toggleTextScale() => setState(() => _largeText = !_largeText);

  FrostedPerformanceData get performance => _performance;

  void setPerformance(FrostedPerformanceData value) =>
      setState(() => _performance = value);

  @override
  Widget build(BuildContext context) {
    return FrostedPerformance.fromData(
      data: _performance,
      child: MaterialApp(
        title: 'Frosted UI Kit Sandbox',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        localizationsDelegates: const [
          ...FrostedAppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: FrostedAppLocalizations.supportedLocales,
        locale: _rightToLeft ? const Locale('ar', '') : const Locale('en', ''),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(_largeText ? 1.35 : 1.0),
            ),
            child: Directionality(
              textDirection: _rightToLeft
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            ),
          );
        },
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey[100],
          extensions: const [FrostedThemeData.light],
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF1F1C2C),
          extensions: const [FrostedThemeData.dark],
        ),
        home: const CatalogHomeScreen(),
      ),
    );
  }
}
