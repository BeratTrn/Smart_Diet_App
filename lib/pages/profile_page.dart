import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/models/user_model.dart';
import 'package:flutter_smart_diet_app/pages/body_fat_page.dart';
import 'package:flutter_smart_diet_app/pages/body_mass_index_page.dart';
import 'package:flutter_smart_diet_app/pages/calorie_category_page.dart';
import 'package:flutter_smart_diet_app/pages/edit_profile_page.dart';
import 'package:flutter_smart_diet_app/pages/home_page.dart';
import 'package:flutter_smart_diet_app/pages/profile_photo_page.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;

  Future<void> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("UID is null. User not logged in.");
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        print("User document is missing or null.");
        return;
      }

      final data = doc.data()!;
      setState(() {
        user = UserModel.fromMap(data);
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(); // sadece async işlemi başlat, veri geldiğinde zaten setState içinde set ediyor
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),

        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: MyAppColors.primaryColor,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[200],
                  backgroundImage:
                      user?.avatar != null ? AssetImage(user!.avatar!) : null,
                  child:
                      user?.avatar == null
                          ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.blue,
                          )
                          : null,
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                    onPressed: () {
                      // avatar resmi seçeceği yere gider
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePhotoPage(),
                        ),
                      );
                      getUserData(); // avatar güncellendiyse yeniden veri çek
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.editprofile,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            // Kişisel Bilgiler Kartı
            Card(
              color: Colors.grey[100],

              child: Container(
                margin: EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    InfoRow(
                      label: AppLocalizations.of(context)!.namesurname,
                      value: user!.name + " " + user!.surname,
                    ),
                    InfoRow(
                      label: AppLocalizations.of(context)!.email,
                      value: user!.email,
                    ),
                    InfoRow(
                      label: AppLocalizations.of(context)!.age,
                      value: user!.age,
                    ),
                    InfoRow(
                      label: AppLocalizations.of(context)!.gender,
                      value: user!.genderText,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Ölçü Kartları
            Card(
              color: Colors.grey[100],

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      bottom: 0,
                      top: 15,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.bodymeasurements,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 20,
                    ),

                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.8,
                      children: [
                        MeasurementCard(
                          label: AppLocalizations.of(context)!.weight,
                          value: user!.weight,
                          unit: 'kg',
                          icon: Icons.monitor_weight,
                        ),
                        MeasurementCard(
                          label: AppLocalizations.of(context)!.height,
                          value: user!.height,
                          unit: 'cm',
                          icon: Icons.height,
                        ),
                        MeasurementCard(
                          label:
                              AppLocalizations.of(context)!.waistcircumference,
                          value: user!.waist,
                          unit: 'cm',
                          icon: Icons.straighten,
                        ),
                        MeasurementCard(
                          label:
                              AppLocalizations.of(context)!.neckcircumference,
                          value: user!.neck,
                          unit: 'cm',
                          icon: Icons.accessibility,
                        ),
                        MeasurementCard(
                          label: AppLocalizations.of(context)!.hipcircumference,
                          value: user!.hip,
                          unit: 'cm',
                          icon: Icons.accessibility_new,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Card(
              color: Colors.grey[100],
              child: Container(
                margin: EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    InfoBody(
                      route: CalorieCategoryPage(),
                      label: AppLocalizations.of(context)!.calorieNeeds,
                    ),
                    InfoBody(
                      route: BodyMassIndexPage(),
                      label: AppLocalizations.of(context)!.yourBodyMassIndex,
                    ),
                    InfoBody(
                      route: BodyFatPage(user: user!),
                      label:
                          AppLocalizations.of(context)!.yourBodyFatPercentage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBody extends StatelessWidget {
  final String label;
  final Widget route;
  const InfoBody({required this.route, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.black))),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 23,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => route),
              );
            },
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final dynamic value; // artık int, double, String hepsini kabul eder

  const InfoRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MeasurementCard extends StatelessWidget {
  final String label;
  final dynamic value;
  final String unit;
  final IconData icon;

  const MeasurementCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue[200]),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$value $unit'.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
