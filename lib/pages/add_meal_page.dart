import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/pages/home_page.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';
import 'package:intl/intl.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  String selectedMeal = 'Öğle';
  List<Map<String, dynamic>> allFoods = [];
  String searchQuery = '';
  Map<String, dynamic>? selectedFood;
  int portion = 100;

  @override
  void initState() {
    super.initState();
    loadAllFoods();
  }

  Future<void> loadAllFoods() async {
    final String jsonString = await rootBundle.loadString(
      'assets/food_data_with_macros.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      allFoods = List<Map<String, dynamic>>.from(jsonList);
    });
  }

  Future<void> saveMealToFirestore() async {
    if (selectedFood == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final double calories = selectedFood!['calories'] * portion / 100;
    final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. Yemek bilgisi normal 'meals' koleksiyonuna ekleniyor

    final mealRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .doc(dateKey)
        .collection(selectedMeal);

    await mealRef.add({
      'foodName': selectedFood!['name'],
      'gram': portion,
      'calorie': calories.toInt(),
      'timestamp': Timestamp.now(),
      'protein': selectedFood!['protein'] * portion / 100,
      'carb': selectedFood!['carbs'] * portion / 100,
      'fat': selectedFood!['fat'] * portion / 100,
    });

    // 2. Günlük toplam kaloriyi istatistiklere ekle
    final statsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('meal_stats')
        .doc(dateKey);

    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snapshot = await tx.get(statsRef);
        if (snapshot.exists) {
          final currentCalories = snapshot.data()?['totalCalories'] ?? 0;
          tx.update(statsRef, {
            'totalCalories': currentCalories + calories.toInt(),
          });
        } else {
          tx.set(statsRef, {
            'totalCalories': calories.toInt(),
            'createdAt': Timestamp.now(),
          });
        }
      });
    } catch (e) {
      print('Transaction error: $e');
    }
  }

  void resetMeal() {
    setState(() {
      selectedFood = null;
      portion = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    var filteredFoods =
        allFoods
            .where(
              (food) => food['name'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    final calorie =
        selectedFood != null
            ? (selectedFood!['calories'] * portion / 100).toInt()
            : 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        title: Text(
          AppLocalizations.of(context)!.addFood,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedFood != null) {
                saveMealToFirestore();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.pleasechooseameal,
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.meal,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    [
                      AppLocalizations.of(context)!.breakfast,
                      AppLocalizations.of(context)!.lunch,
                      AppLocalizations.of(context)!.dinner,
                      AppLocalizations.of(context)!.snack,
                    ].map((meal) {
                      return ChoiceChip(
                        backgroundColor: Colors.blue.shade50,
                        selectedColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white54
                                : Colors.grey.shade300,
                        label: mealIconText(context, meal),
                        selected: selectedMeal == meal,
                        onSelected: (val) {
                          setState(() {
                            selectedMeal = meal;
                            resetMeal();
                          });
                        },
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: MyAppColors.primaryColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: MyAppColors.primaryColor),
                ),
                focusColor: MyAppColors.primaryColor,
                labelText: AppLocalizations.of(context)!.searchforFood,
                prefixIcon: Icon(Icons.search, color: Colors.blue.shade500),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
            if (filteredFoods.isNotEmpty && selectedFood == null)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];
                    return ListTile(
                      title: Text(food['name']),
                      onTap: () => setState(() => selectedFood = food),
                    );
                  },
                ),
              ),
            if (selectedFood != null) ...[
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.selectedMeal +
                    ": ${selectedFood!['name']}",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.portiongrams),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed:
                            () => setState(
                              () => portion = (portion - 1).clamp(10, 3000),
                            ),
                      ),
                      Text('$portion g'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed:
                            () => setState(
                              () => portion = (portion + 1).clamp(10, 3000),
                            ),
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context)!.calorie + ": $calorie kcal",
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap:
                        () => setState(
                          () => portion = (portion - 50).clamp(10, 3000),
                        ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '-50',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap:
                        () => setState(
                          () => portion = (portion + 10).clamp(10, 3000),
                        ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '+10',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap:
                        () => setState(
                          () => portion = (portion + 50).clamp(10, 3000),
                        ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '+50',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap:
                        () => setState(
                          () => portion = (portion + 100).clamp(10, 3000),
                        ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '+100',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      AppLocalizations.of(context)!.nutritionalValues,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NutritionBox(
                        value: selectedFood!['protein'] * portion / 100,
                        label: AppLocalizations.of(context)!.protein,
                        backgroundColor: Color(0xFFFFEBEB),
                        textColor: Color(0xFFD10000),
                      ),
                      _NutritionBox(
                        value: selectedFood!['carbs'] * portion / 100,
                        label: AppLocalizations.of(context)!.carbohydrate,
                        backgroundColor: Color(0xFFE5F6FF),
                        textColor: Color(0xFF0080C9),
                      ),
                      _NutritionBox(
                        value: selectedFood!['fat'] * portion / 100,
                        label: AppLocalizations.of(context)!.oil,
                        backgroundColor: Color(0xFFFFF3D6),
                        textColor: Color(0xFFF5A623),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NutritionBox extends StatelessWidget {
  final double value;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _NutritionBox({
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
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
}

Widget mealIconText(BuildContext context, String meal) {
  return Row(
    children: [
      Text(meal, style: TextStyle(color: Colors.black)),
      SizedBox(width: 5),
      Icon(Icons.restaurant, size: 15, color: Colors.blue.shade400),
    ],
  );
}
