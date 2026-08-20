import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/features/home/persentation/screen/home.dart';
import 'package:frosted_ui_kit/src/utils/app_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

/// Root application widget configuring themes and localization delegates.
class MainApp extends StatelessWidget {
  /// Creates a [MainApp].
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: AppThemes.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('ar'),
      home: const Home(),
    );
  }
}
