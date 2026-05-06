import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/pages/Auth/forgot_password_page.dart';
import 'package:flutter_smart_diet_app/pages/Auth/sign_page.dart';
import 'package:flutter_smart_diet_app/pages/home_page.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FirebaseAuth auth;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  void loginUserEmailAndPassword() async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lütfen e-posta adresinizi doğrulayın."),
          ),
        );
        return;
      }

      final uid = userCredential.user!.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Kullanıcı verisi bulunamadı. Lütfen tekrar kayıt olun.",
            ),
          ),
        );
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = switch (e.code) {
        'user-not-found' => "Kullanıcı bulunamadı.",
        'wrong-password' => "Şifre yanlış.",
        'invalid-email' => "Geçersiz e-posta.",
        _ => "Hata: ${e.message}",
      };

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login sırasında bilinmeyen hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: MyAppColors.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.smartDiet,

                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: MyAppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 48),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: MyAppColors.primaryColor),
                      ),
                      hintText: AppLocalizations.of(context)!.email,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: MyAppIcons.mailIcon,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: MyAppColors.primaryColor),
                      ),
                      hintText: AppLocalizations.of(context)!.password,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: MyAppIcons.lockIcon,
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: MyAppColors.primaryColor,
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed:
                            () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Beni hatırla
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: controller.rememberMe.value,
                    //       onChanged: (_) => controller.toggleRememberMe(),
                    //       activeColor: MyAppColors.primaryColor,
                    //     ),
                    //     Text(
                    //       'Beni hatırla',
                    //       style: TextStyle(
                    //         color: Colors.grey.shade700,
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.iforgotmypassword,

                        style: TextStyle(
                          color: MyAppColors.primaryColor,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    loginUserEmailAndPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyAppColors.primaryColor,
                    foregroundColor: MyAppColors.backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.login,

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignPage()),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.dontthaveanaccountSignup,
                    style: TextStyle(
                      color: MyAppColors.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
