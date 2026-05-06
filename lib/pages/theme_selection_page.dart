import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/services/theme_helper.dart';

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({super.key});

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  ThemeMode? _currentMode;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefsTheme = await ThemeHelper.getThemeMode();
    setState(() {
      _currentMode = prefsTheme;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('settings')
              .doc(user.uid)
              .get();

      final firestoreTheme = doc.data()?['theme'];
      if (firestoreTheme != null) {
        ThemeMode modeFromFirestore =
            firestoreTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

        if (_currentMode != modeFromFirestore) {
          setState(() {
            _currentMode = modeFromFirestore;
          });
          await ThemeHelper.saveThemeMode(modeFromFirestore);
        }
      }
    }
  }

  void _onThemeChanged(ThemeMode? mode) async {
    if (mode == null) return;

    await ThemeHelper.saveThemeMode(mode);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('settings') // 🔄 Yeni koleksiyon
          .doc(user.uid)
          .set({
            'theme': mode == ThemeMode.dark ? 'dark' : 'light',
          }, SetOptions(merge: true));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          )!.changingthethemerequiresrestartingtheapp,
        ),
      ),
    );

    setState(() {
      _currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.selectTheme,
            style: TextStyle(fontSize: 18),
          ),
          RadioListTile<ThemeMode>(
            activeColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            value: ThemeMode.light,
            groupValue: _currentMode,
            onChanged: _onThemeChanged,
            title: Text(AppLocalizations.of(context)!.lightTheme),
          ),
          RadioListTile<ThemeMode>(
            activeColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            value: ThemeMode.dark,
            groupValue: _currentMode,
            onChanged: _onThemeChanged,
            title: Text(AppLocalizations.of(context)!.darkTheme),
          ),
        ],
      ),
    );
  }
}
