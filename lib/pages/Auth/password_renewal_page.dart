import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class PasswordRenewalPage extends StatefulWidget {
  @override
  _PasswordRenewalPageState createState() => _PasswordRenewalPageState();
}

class _PasswordRenewalPageState extends State<PasswordRenewalPage> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _newPassRepeatController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  bool _obscurePassword3 = true;

  Future<void> _updatePassword() async {
    final oldPass = _oldPassController.text.trim();
    final newPass = _newPassController.text.trim();
    final newPassRepeat = _newPassRepeatController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || newPassRepeat.isEmpty) {
      _showMessage("Lütfen tüm alanları doldurun.");
      return;
    }

    if (newPass != newPassRepeat) {
      _showMessage("Yeni şifreler eşleşmiyor.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (email != null && user != null) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: oldPass,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPass);

        _showMessage("Şifreniz başarıyla güncellendi.");
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showMessage("Eski şifre yanlış.");
      } else if (e.code == 'weak-password') {
        _showMessage("Yeni şifre çok zayıf.");
      } else {
        _showMessage("Hata: ${e.message}");
      }
    } catch (e) {
      _showMessage("Bir hata oluştu: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: MyAppIcons.backIcon,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Şifre Yenileme",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Lütfen eski şifrenizi girin.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Yeni şifre alanı
              const Text(
                'Eski Şifre',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _oldPassController,
                obscureText: _obscurePassword1,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: MyAppColors.primaryColor),
                  ),
                  hintText: 'Yeni şifrenizi giriniz',
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: MyAppColors.primaryColor,
                      _obscurePassword1
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword1 = !_obscurePassword1,
                        ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Lütfen yeni şifrenizi girin.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Yeni şifre alanı
              const Text(
                'Yeni Şifre',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPassController,
                obscureText: _obscurePassword2,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: MyAppColors.primaryColor),
                  ),
                  hintText: 'Yeni şifrenizi giriniz',
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: MyAppColors.primaryColor,
                      _obscurePassword2
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword2 = !_obscurePassword2,
                        ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Şifre tekrar alanı
              const Text(
                'Yeni Şifre Tekrar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPassRepeatController,
                obscureText: _obscurePassword3,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: MyAppColors.primaryColor),
                  ),
                  hintText: 'Yeni şifrenizi tekrar giriniz',
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: MyAppColors.primaryColor,
                      _obscurePassword3
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword3 = !_obscurePassword3,
                        ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Buton
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyAppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Devam Et',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
