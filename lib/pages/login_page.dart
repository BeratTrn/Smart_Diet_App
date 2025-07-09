import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/pages/forgot_password_page.dart';
import 'package:flutter_smart_diet_app/pages/sign_page.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

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
                  'Akıllı Diyet',
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
                      hintText: 'E-posta',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: MyAppColors.primaryColor,
                      ),
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
                    decoration: InputDecoration(
                      hintText: 'Şifre',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: MyAppColors.primaryColor,
                      ),
                      // suffixIcon: IconButton(
                      //   icon: Icon(
                      //     controller.isPasswordVisible.value
                      //         ? Icons.visibility
                      //         : Icons.visibility_off,
                      //     color: Colors.blue.shade800,
                      //   ),
                      //   onPressed: controller.togglePasswordVisibility,
                      // ),
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
                        'Şifremi unuttum',
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyAppColors.primaryColor,
                    foregroundColor: MyAppColors.backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Giriş Yap',
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
                    'Hesabın yok mu? Kayıt ol',
                    style: TextStyle(color: MyAppColors.primaryColor, fontSize: 16),
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
