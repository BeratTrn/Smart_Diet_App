import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/pages/home_page.dart';
import 'package:intl/intl.dart';

class MealDetailPage extends StatelessWidget {
  final String mealLabel;
  final String details;
  final int calories;
  final DateTime dateTime;
  final double protein;
  final double carb;
  final double fat;
  final String mealId;

  const MealDetailPage({
    super.key,
    required this.mealLabel,
    required this.details,
    required this.calories,
    required this.dateTime,
    required this.protein,
    required this.carb,
    required this.fat,
    required this.mealId,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'dd MMMM yyyy - HH:mm',
      'tr_TR',
    ).format(dateTime);

    return Scaffold(
      appBar: AppBar(title: Text('$mealLabel Detayı'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.restaurant_menu,
                    size: 48,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    details,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.totalCalories +
                        ": $calories kcal",
                    style: const TextStyle(fontSize: 18, color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.additiontime +
                        ": $formattedDate",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.nutritionalValues,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _nutritionBox(
                  label: AppLocalizations.of(context)!.protein,
                  value: protein,
                  backgroundColor: Color(0xFFFFEBEB), // Açık kırmızımsı
                  textColor: Color(0xFFD10000),
                ),
                _nutritionBox(
                  label: AppLocalizations.of(context)!.carbohydrate,
                  value: carb,
                  backgroundColor: Color(0xFFE5F6FF), // Açık mavi
                  textColor: Color(0xFF0080C9),
                ),
                _nutritionBox(
                  label: AppLocalizations.of(context)!.oil,
                  value: fat,
                  backgroundColor: Color(0xFFFFF3D6), // Açık turuncu
                  textColor: Color(0xFFF5A623),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await deleteMealById(
                  dateTime: dateTime,
                  mealLabel: mealLabel,
                  mealId: mealId,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: const Icon(Icons.delete_outline),
              label: Text(AppLocalizations.of(context)!.deleteFood),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionBox({
    required String label,
    required double value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '${value.toStringAsFixed(1)} g',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

 Future<void> deleteMealById({
  required DateTime dateTime,
  required String mealLabel,
  required String mealId,
}) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final dateKey = DateFormat('yyyy-MM-dd').format(dateTime);

  final mealDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('meals')
      .doc(dateKey)
      .collection(mealLabel)
      .doc(mealId);

  final statsDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('meal_stats')
      .doc(dateKey);

  // 1. Önce yemeğin verisini al
  final mealSnapshot = await mealDocRef.get();
  if (!mealSnapshot.exists) return;

  final int calories = (mealSnapshot.data()?['calorie'] ?? 0).toInt();

  // 2. Yemeği sil
  await mealDocRef.delete();

  // 3. İstatistikten çıkar (transaction ile güvenli şekilde)
  await FirebaseFirestore.instance.runTransaction((tx) async {
    final statsSnapshot = await tx.get(statsDocRef);

    if (!statsSnapshot.exists) return;

    final current = (statsSnapshot.data()?['totalCalories'] ?? 0).toInt();
    final updated = current - calories;

    if (updated <= 0) {
      tx.delete(statsDocRef);
    } else {
      tx.update(statsDocRef, {'totalCalories': updated});
    }
  });
}

}
