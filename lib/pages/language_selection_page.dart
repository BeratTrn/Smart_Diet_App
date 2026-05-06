import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const LanguageSelectionPage({super.key, required this.onLocaleChange});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late Locale _selectedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLocale = Localizations.localeOf(context);
  }

  final List<Locale> supportedLocales = const [
    Locale('tr'),
    Locale('en'),
    Locale('fr'),
    Locale('de'),
    Locale('pt'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLangCode = prefs.getString('languageCode');

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
          .collection('users')
              .doc(user.uid)
              .collection('settings')
              .doc(user.uid)
              .get();
      final firestoreLang = doc.data()?['language'];

      final langCode = firestoreLang ?? savedLangCode ?? 'tr';

      setState(() {
        _selectedLocale = Locale(langCode);
      });

      // local değişikliği uygula
      widget.onLocaleChange(Locale(langCode));
    } else {
      setState(() {
        _selectedLocale = Locale(savedLangCode ?? 'tr');
      });
    }
  }

  Future<void> _onLanguageChanged(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users')
              .doc(user.uid).collection('settings').doc(user.uid).set(
        {'language': locale.languageCode},
        SetOptions(merge: true),
      );
    }

    setState(() {
      _selectedLocale = locale;
    });

    widget.onLocaleChange(locale);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          )!.thelanguagehasbeenchangedItrequiresyoutorestarttheapplication,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.selectLanguage,
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 50, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.selectLanguage,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton<Locale>(
                  value: _selectedLocale,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  elevation: 4,
                  borderRadius: BorderRadius.circular(15),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  dropdownColor: Colors.white,
                  items:
                      supportedLocales.map((locale) {
                        return DropdownMenuItem(
                          value: locale,
                          child: Text(
                            _getLanguageName(locale.languageCode),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                  onChanged: (locale) {
                    if (locale != null) {
                      _onLanguageChanged(locale);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'pt':
        return 'Português';
      default:
        return code.toUpperCase();
    }
  }
}
