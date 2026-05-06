import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CalorieCategoryPage extends StatefulWidget {
  const CalorieCategoryPage({super.key});

  @override
  State<CalorieCategoryPage> createState() => _CalorieCategoryPageState();
}

class _CalorieCategoryPageState extends State<CalorieCategoryPage> {
  int selectedGoal = 1; // 0: kilo vermek, 1: korumak, 2: almak
  int bmr = 0;
  int dailyCalories = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndCalculate();
  }

  Future<void> fetchUserDataAndCalculate() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();

      if (data != null) {
        final double height = (data['height'] as num).toDouble();
        final double weight = (data['weight'] as num).toDouble();
        final int age = data['age'];
        final String gender = data['gender'];

        double calculatedBMR = 0;

        if (gender.toLowerCase() == 'erkek') {
          calculatedBMR = 10 * weight + 6.25 * height - 5 * age + 5;
        } else {
          calculatedBMR = 10 * weight + 6.25 * height - 5 * age - 161;
        }

        int baseCalories = (calculatedBMR * 1.5).round();

        // Kaydedilmiş kalori hedefini ve goal'u çek
        String docId = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final calorieDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('calorieInfo')
            .doc(docId)
            .get();

        int currentDailyCalories = baseCalories;
        int savedGoal = 1; // Varsayılan: korumak

        if (calorieDoc.exists) {
          final calorieData = calorieDoc.data();
          if (calorieData != null) {
            currentDailyCalories = calorieData['dailyCalorie'] ?? baseCalories;
            savedGoal = calorieData['selectedGoalIndex'] ?? 1;
          }
        }

        setState(() {
          bmr = calculatedBMR.round();
          dailyCalories = currentDailyCalories; // VT'den gelen değer
          selectedGoal = savedGoal; // Kaydedilmiş hedef
          isLoading = false;
        });
      } else {
        throw Exception("Kullanıcı verisi bulunamadı.");
      }
    } catch (e) {
      print("Hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Seçilen hedefe göre kalori hesaplama fonksiyonu
  int getTargetCalories() {
    // BMR'dan temel kalori hesapla
    int baseCalories = (bmr * 1.5).round();
    int lose = (baseCalories - 500);
    if (lose < 1200) lose = 1200;
    int gain = baseCalories + 500;

    switch (selectedGoal) {
      case 0: // Kilo vermek
        return lose;
      case 1: // Kilo korumak
        return baseCalories;
      case 2: // Kilo almak
        return gain;
      default:
        return baseCalories;
    }
  }

  @override
  Widget build(BuildContext context) {
    // BMR'dan temel kalori hesapla (koruma için)
    int baseCalories = (bmr * 1.5).round();
    int lose = (baseCalories - 500);
    if (lose < 1200) lose = 1200;
    int gain = baseCalories + 500;

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.grey[100],
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        title: Text(
          AppLocalizations.of(context)!.calorieNeeds,
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: MyAppIcons.backIcon,
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourDailyCalorieNeeds,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.calculatedbasedonyourheightweightageandactivitylevel,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Bazal ve Günlük Kalori
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _calorieRow(
                            FontAwesomeIcons.fire,
                            AppLocalizations.of(context)!.basalMetabolicRate,
                            "$bmr kcal",
                            Colors.blue.shade100,
                          ),
                          const SizedBox(height: 12),
                          _calorieRow(
                            FontAwesomeIcons.utensils,
                            AppLocalizations.of(context)!.dailyCalorieNeeds,
                            "$dailyCalories kcal", // VT'den gelen güncel değer
                            Colors.green.shade100,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.accordingtoYourGoals,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Hedef Kartları
                    _goalCard(
                      0,
                      AppLocalizations.of(context)!.loseweight,
                      "$lose kcal/gün",
                      Icons.trending_down,
                      Colors.orange.shade100,
                      Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    _goalCard(
                      1,
                      AppLocalizations.of(context)!.maintainingWeight,
                      "$baseCalories kcal/gün", // Temel kalori
                      Icons.balance,
                      Colors.blue.shade100,
                      Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _goalCard(
                      2,
                      AppLocalizations.of(context)!.gainweight,
                      "$gain kcal/gün",
                      Icons.trending_up,
                      Colors.green.shade100,
                      Colors.green,
                    ),

                    const Spacer(),

                    // Kaydet Butonu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid == null) return;

                          String goalText = '';
                          switch (selectedGoal) {
                            case 0:
                              goalText = 'Kilo Vermek';
                              break;
                            case 1:
                              goalText = 'Kilo Korumak';
                              break;
                            case 2:
                              goalText = 'Kilo Almak';
                              break;
                          }

                          try {
                            // Seçilen hedefe göre kalori hesapla
                            int targetCalories = getTargetCalories();

                            // Belge adı olarak tarih-saat formatı
                            String docId = DateFormat(
                              'yyyy-MM-dd',
                            ).format(DateTime.now());

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('calorieInfo') // ALT KOLEKSİYON
                                .doc(
                                  docId,
                                ) // TARİHİ BELGE ID OLARAK KULLANIYORUZ
                                .set({
                                  'bmr': bmr,
                                  'dailyCalorie': targetCalories, // Seçilen hedefe göre ayarlanmış kalori
                                  'baseCalorie': (bmr * 1.5).round(), // Temel kalori ihtiyacı (korunma)
                                  'goal': goalText,
                                  'selectedGoalIndex': selectedGoal, // Index de kaydedelim
                                  'timestamp': FieldValue.serverTimestamp(),
                                });

                            // Sayfadaki günlük kalori değerini güncelle
                            setState(() {
                              dailyCalories = targetCalories;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Hedef başarıyla kaydedildi! Günlük kalori hedefi: $targetCalories kcal'),
                              ),
                            );

                            Navigator.pop(context);
                          } catch (e) {
                            print('🔥 Hedef kaydedilirken hata: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hedef kaydedilemedi!')),
                            );
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.save,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _calorieRow(IconData icon, String title, String value, Color bgColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: bgColor,
          child: FaIcon(icon, color: Colors.black54, size: 25),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _goalCard(
    int index,
    String title,
    String value,
    IconData icon,
    Color bgColor,
    Color borderColor,
  ) {
    bool isSelected = index == selectedGoal;
    return InkWell(
      onTap: () => setState(() => selectedGoal = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: borderColor, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: borderColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: borderColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(value, style: TextStyle(color: borderColor, fontSize: 14)),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}