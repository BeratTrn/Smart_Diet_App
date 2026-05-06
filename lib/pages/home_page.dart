import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/pages/Auth/login_page.dart';
import 'package:flutter_smart_diet_app/pages/add_meal_page.dart';
import 'package:flutter_smart_diet_app/pages/meal_detail_page.dart';
import 'package:flutter_smart_diet_app/pages/meal_planner_page.dart';
import 'package:flutter_smart_diet_app/pages/notes_page.dart';
import 'package:flutter_smart_diet_app/pages/profile_page.dart';
import 'package:flutter_smart_diet_app/pages/settings_page.dart';
import 'package:flutter_smart_diet_app/pages/stats_page.dart';
import 'package:flutter_smart_diet_app/pages/water_tracker_page.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  int? dailyCalorie;
  bool isCalorieLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchDailyCalorie(); // Başlangıçta kalori bilgisi çek
    });
  }

  Future<Map<String, List<Map<String, dynamic>>>>
  fetchMealsFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);

    final userMealsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('meals')
        .doc(dateKey);

    final meals = <String, List<Map<String, dynamic>>>{};

    final mealTypes = ['Kahvaltı', 'Öğle', 'Akşam', 'Atıştırma'];

    for (final mealType in mealTypes) {
      final querySnapshot =
          await userMealsCollection.collection(mealType).get();

      if (querySnapshot.docs.isNotEmpty) {
        meals[mealType] =
            querySnapshot.docs.map((doc) {
              final data = doc.data();
              return {
                ...data,
                'mealId': doc.id, // ← Burada doküman ID’yi ekliyoruz
              };
            }).toList();
      }
    }

    return meals;
  }

  Future<void> fetchDailyCalorie() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final calorie = await getLatestDailyCalorie(uid);
    setState(() {
      dailyCalorie = calorie;
      isCalorieLoading = false;
    });
  }

  Future<int?> getLatestDailyCalorie(String uid) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('calorieInfo')
              .orderBy('timestamp', descending: true) // En son veriyi getir
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['dailyCalorie'] as int?;
      } else {
        return null; // veri yoksa
      }
    } catch (e) {
      print("Günlük kalori alınamadı: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
    final dayMeals = localMealStorage[dateKey] ?? {};
    final totalCalories = dayMeals.values
        .expand((list) => list)
        .fold<int>(0, (sum, item) => sum + item['calorie'] as int);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : MyAppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : MyAppColors.backgroundColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.homePage,

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.blue
                    : Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
            onPressed: () {
              showMenu(
                color: Colors.blue[50],
                context: context,
                position: RelativeRect.fromLTRB(100, 50, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: MyAppIcons.profileIcon,
                      title: Text(
                        AppLocalizations.of(context)!.profile,

                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: MyAppIcons.statsIcon,
                      title: Text(
                        AppLocalizations.of(context)!.statistics,

                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StatsPage()),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: MyAppIcons.waterIcon,
                      title: Text(
                        AppLocalizations.of(context)!.waterTracking,

                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaterTrackerPage(),
                          ),
                        );
                      },
                    ),
                  ),

                  PopupMenuItem(
                    child: ListTile(
                      leading: MyAppIcons.settingsIcon,
                      title: Text(
                        AppLocalizations.of(context)!.settings,

                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: MyAppIcons.logoutIcon,
                      title: Text(
                        AppLocalizations.of(context)!.logOut,

                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  AppLocalizations.of(context)!.logOut,
                                ),
                                content: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.areyousureyouwanttologout,
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
                                    onPressed: () {
                                      // Çıkış işlemi burada yapılabilir (örneğin, oturumu kapatma)
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.logOut,

                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchMealsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: MyAppColors.primaryColor),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          }
          final dayMeals = snapshot.data ?? {};
          final totalCalories = dayMeals.values
              .expand((list) => list)
              .fold<int>(0, (sum, item) => sum + (item['calorie'] as int));

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 16,
              left: 16,
              right: 16,
              top: 5,
            ),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    buildDateHeader(),
                    const SizedBox(height: 16),
                    buildCalorieSummary(totalCalories),
                    const SizedBox(height: 20),
                    buildMealCategoryList(dayMeals),
                    const SizedBox(height: 20),
                  ]),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpeedDial(
                        elevation: 2,
                        icon: Icons.note,
                        activeIcon: Icons.close,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        children: [
                          SpeedDialChild(
                            elevation: 2,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Notlarım",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotesPage(),
                                ),
                              );
                            },
                          ),
                          SpeedDialChild(
                            elevation: 2,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Yemek Planlayıcım",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealPlannerPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      FloatingActionButton(
                        elevation: 2,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddMealPage()),
                          );
                          setState(() {}); // Yeniden yükle
                        },
                        child: const Icon(Icons.add, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDateHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: Colors.blue,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  selectedDate = selectedDate.subtract(const Duration(days: 7));
                });
              },
            ),
            Text(
              formattedMonth(context, selectedDate),
              style: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              color: Colors.blue,
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  selectedDate = selectedDate.add(const Duration(days: 7));
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final date = selectedDate.subtract(
              Duration(days: selectedDate.weekday - 1 - index),
            );
            final isSelected =
                date.day == selectedDate.day &&
                date.month == selectedDate.month;
            final weekDay = formattedDay(context, date);
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
              },
              child: Column(
                children: [
                  Text(
                    weekDay.substring(0, 3),
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : isSelected
                              ? Colors.blue
                              : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        isSelected ? Colors.blue : Colors.transparent,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : isSelected
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildCalorieSummary(int totalCalories) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withOpacity(0.1),
                  border: Border.all(color: Colors.orange),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$totalCalories',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalCalories,

                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    dailyCalorie != null
                        ? "${AppLocalizations.of(context)!.yourdailygoal}: $dailyCalorie kcal"
                        : "Günlük kalori hedefini seçebilirsin...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          isCalorieLoading || dailyCalorie == null
              ? Icon(Icons.question_mark, color: Colors.orange)
              : CircularProgressIndicator(
                value: (totalCalories / dailyCalorie!).clamp(0.0, 1.0),
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                strokeWidth: 5,
              ),
        ],
      ),
    );
  }

  Widget buildMealCategoryList(
    Map<String, List<Map<String, dynamic>>> dayMeals,
  ) {
    if (dayMeals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Text(AppLocalizations.of(context)!.nofoodhasbeenaddedfortoday),
        ),
      );
    }

    // Sabit öğün sıralaması
    final mealOrder = ['Kahvaltı', 'Öğle', 'Akşam', 'Atıştırma'];

    // İkonlar
    final mealIcons = {
      'Kahvaltı': Icons.free_breakfast,
      'Öğle': Icons.lunch_dining,
      'Akşam': Icons.dinner_dining,
      'Atıştırma': Icons.fastfood,
    };

    final filteredMeals =
        mealOrder.where((mealType) {
          return dayMeals.containsKey(mealType) &&
              dayMeals[mealType]!.isNotEmpty;
        }).toList();

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children:
          filteredMeals.map((mealType) {
            final meals = dayMeals[mealType]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Text(
                    mealType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...meals.map((meal) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          mealIcons[mealType] ?? Icons.restaurant,
                          color: Colors.orange,
                          size: 25,
                        ),
                      ),
                      title: Text(meal['foodName'] ?? 'Yemek'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${meal['calorie'] ?? 0} kcal',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      onTap: () async {
                        final dateTime =
                            (meal['timestamp'] as Timestamp?)?.toDate() ??
                            DateTime.now();

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MealDetailPage(
                                  calories: meal['calorie'] ?? 0,
                                  dateTime: dateTime,
                                  mealLabel: mealType,
                                  details: meal['foodName'] ?? '',
                                  protein: (meal['protein'] ?? 0).toDouble(),
                                  carb: (meal['carb'] ?? 0).toDouble(),
                                  fat: (meal['fat'] ?? 0).toDouble(),
                                  mealId: meal['mealId'],
                                ),
                          ),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                    ),
                  );
                }),
              ],
            );
          }).toList(),
    );
  }

  String formattedMonth(BuildContext context, DateTime selectedDate) {
    final localeCode = Localizations.localeOf(context).languageCode;

    // Desteklenen diller
    final supportedLocales = ['tr', 'fr', 'de', 'pt', 'en'];

    // Eğer desteklenmeyen bir dil gelirse en_US kullan
    final locale =
        supportedLocales.contains(localeCode)
            ? '${localeCode}_${localeCode.toUpperCase()}'
            : 'en_US';

    return DateFormat('MMMM yyyy', locale).format(selectedDate);
  }

  String formattedDay(BuildContext context, DateTime date) {
    final localeCode = Localizations.localeOf(context).languageCode;

    // Desteklenen diller
    final supportedLocales = ['tr', 'fr', 'de', 'pt', 'en'];

    // Eğer desteklenmeyen bir dil gelirse en_US kullan
    final locale =
        supportedLocales.contains(localeCode)
            ? '${localeCode}_${localeCode.toUpperCase()}'
            : 'en_US';

    return DateFormat('EEE', locale).format(date);
  }
}
