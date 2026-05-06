import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/firebase_options.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/pages/splash_page.dart';
import 'package:flutter_smart_diet_app/services/language_helper.dart';
import 'package:flutter_smart_diet_app/services/theme_helper.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  final savedThemeMode = await ThemeHelper.getThemeMode();
  final savedLocale = await LanguageHelper.getSavedLocale();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(savedThemeMode, savedLocale));
}

class MyApp extends StatefulWidget {
  final ThemeMode themeMode;
  final Locale savedLocale;

  const MyApp(this.themeMode, this.savedLocale, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.savedLocale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Diet App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: widget.themeMode,
      home: SplashPage(),
      locale: _locale,
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('fr'),
        Locale('de'),
        Locale('pt'),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
