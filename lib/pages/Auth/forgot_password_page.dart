import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Şifre sıfırlama e-postası gönderildi.E-postanızı kontrol etmeyi unutmayınız.",
          ),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Geri butonu
              IconButton(
                icon: MyAppIcons.backIcon,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 32),

              // Başlık
              Text(
                AppLocalizations.of(context)!.passwordRenewal,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Açıklama
              Text(
                AppLocalizations.of(
                  context,
                )!.enteryourregisteredemailaddressApasswordresetcode,

                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // E-mail input
              Text(
                AppLocalizations.of(context)!.email,

                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: MyAppColors.primaryColor),
                  ),
                  hintText: AppLocalizations.of(context)!.enteryouremailaddress,
                  hintStyle: const TextStyle(color: Colors.black26),
                  filled: true,
                  fillColor: MyAppColors.backgroundColor,
                  prefixIcon: MyAppIcons.mailIcon,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Kod Gönder Butonu
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    sendPasswordResetEmail(email);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: MyAppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                            AppLocalizations.of(context)!.sendCode,

                            style: TextStyle(
                              fontSize: 16,
                              color: MyAppColors.primaryColor,
                            ),
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
