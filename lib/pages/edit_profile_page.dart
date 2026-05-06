import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/pages/profile_page.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController neckController = TextEditingController();
  final TextEditingController hipController = TextEditingController();

  Future<void> updateUserProfile(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': nameController.text.trim(),
        'surname': surnameController.text.trim(),
        'age': int.parse(ageController.text.trim()),
        'height': double.parse(heightController.text.trim()),
        'weight': double.parse(weightController.text.trim()),
        'waist': double.parse(waistController.text.trim()),
        'neck': double.parse(neckController.text.trim()),
        'hip': double.parse(hipController.text.trim()),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profil başarıyla güncellendi')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: MyAppIcons.backIcon,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.editprofile,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade400,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.personalInformation,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyAppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            buildTextField(
              AppLocalizations.of(context)!.name,
              nameController,
              Icons.person,
            ),
            buildTextField(
              AppLocalizations.of(context)!.surname,
              surnameController,
              Icons.person_outline,
            ),
            buildTextField(
              AppLocalizations.of(context)!.age,
              ageController,
              Icons.calendar_today,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade400,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                SizedBox(width: 10),

                Text(
                  AppLocalizations.of(context)!.bodymeasurements,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyAppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            buildTextField(
              AppLocalizations.of(context)!.height + " (cm)",
              heightController,
              Icons.height,
            ),
            buildTextField(
              AppLocalizations.of(context)!.weight + " (kg)",
              weightController,
              Icons.monitor_weight,
            ),
            buildTextField(
              AppLocalizations.of(context)!.waistcircumference + " (cm)",
              waistController,
              Icons.straighten,
            ),
            buildTextField(
              AppLocalizations.of(context)!.neckcircumference + " (cm)",
              neckController,
              Icons.accessibility,
            ),
            buildTextField(
              AppLocalizations.of(context)!.hipcircumference + " (cm)",
              hipController,
              Icons.accessibility_new,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: MyAppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Burada veriler kaydedilir
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  updateUserProfile(uid);
                },
                child: Text(
                  AppLocalizations.of(context)!.save,
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
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyAppColors.primaryColor),
          ),
          labelText: label,
          floatingLabelStyle: TextStyle(color: MyAppColors.primaryColor),
          prefixIcon: Icon(icon),
          suffixIcon: Icon(Icons.edit, color: Colors.black54),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
