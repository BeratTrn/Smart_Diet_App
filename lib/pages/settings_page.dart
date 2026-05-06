import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/pages/Auth/login_page.dart';
import 'package:flutter_smart_diet_app/pages/Auth/password_renewal_page.dart';
import 'package:flutter_smart_diet_app/pages/about_app_page.dart';
import 'package:flutter_smart_diet_app/pages/contact_page.dart';
import 'package:flutter_smart_diet_app/pages/edit_profile_page.dart';
import 'package:flutter_smart_diet_app/pages/home_page.dart';
import 'package:flutter_smart_diet_app/pages/language_selection_page.dart';
import 'package:flutter_smart_diet_app/pages/theme_selection_page.dart';
import 'package:flutter_smart_diet_app/services/language_helper.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications') ?? true;
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _updateNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  void changeLocale(Locale newLocale) async {
    Locale _locale = const Locale('tr'); // Varsayılan dil

    setState(() {
      _locale = newLocale;
    });
    await LanguageHelper.saveLocale(newLocale);
  }

  Future<void> deleteAccount(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 1. Giriş bilgileriyle yeniden doğrulama
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // 2. Firestore verisini sil
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // 3. Auth hesabını sil
        await user.delete();

        // 4. Login sayfasına dön
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      print('Hesap silinirken hata oluştu: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hesap silinemedi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          icon: MyAppIcons.backIcon,
        ),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSectionTitle(AppLocalizations.of(context)!.userSettings),
          _buildTile(
            Icons.person,
            AppLocalizations.of(context)!.updateProfileInformation,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
          _buildTile(
            Icons.lock,
            AppLocalizations.of(context)!.changePassword,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordRenewalPage()),
              );
            },
          ),
          _buildTile(
            Icons.logout,
            'Hesabı Sil',
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        AppLocalizations.of(context)!.accountWillBeDeleted,
                      ),
                      content: Text(
                        AppLocalizations.of(
                              context,
                            )!.areyousureyouwanttodeletetheaccount +
                            "?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!.delete,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.red,
                            ),
                          ),
                          onPressed: () async {
                            // Çıkış işlemi burada yapılabilir (örneğin, oturumu kapatma)
                            showDeleteDialog(
                              context,
                              FirebaseAuth.instance.currentUser!.email!,
                            );
                          },
                        ),
                      ],
                    ),
              );
            },
          ),

          const Divider(height: 40),

          _buildSectionTitle(AppLocalizations.of(context)!.appSettings),
          _buildTile(
            Icons.notifications,
            AppLocalizations.of(context)!.turnNotificationsOnOff,
            trailing: Switch(
              activeColor: Colors.black,
              value: _notificationsEnabled,
              onChanged: (value) {
                _updateNotificationPreference(value);
              },
            ),
          ),

          _buildTile(
            Icons.palette,
            AppLocalizations.of(context)!.selectTheme,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeSelectionPage(),
                ),
              );
            },
          ),
          _buildTile(
            Icons.language,
            AppLocalizations.of(context)!.selectLanguage,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          LanguageSelectionPage(onLocaleChange: changeLocale),
                ),
              );
            },
          ),

          const Divider(height: 40),

          _buildSectionTitle(AppLocalizations.of(context)!.about),
          _buildTile(
            Icons.info,
            AppLocalizations.of(context)!.aboutTheApp,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutAppPage()),
              );
            },
          ),
          _buildTile(
            Icons.email,
            AppLocalizations.of(context)!.contactFeedback,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 30),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context, String email) {
    final TextEditingController passwordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Hesabı Sil"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyAppColors.primaryColor),
              ),
              floatingLabelStyle: TextStyle(color: MyAppColors.primaryColor),
              labelText: "Şifrenizi girin",
            ),
          ),
          actions: [
            TextButton(
              child: Text("İptal", style: TextStyle(color: Colors.black)),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  ),
            ),
            TextButton(
              child: Text("Hesabı Sil", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAccount(context, email, passwordController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
