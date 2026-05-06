import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int dailyCalorieGoal = 2000; // Varsayılan değer, VT'den güncellenecek
  int weeklyCalorieGoal = 14000; // dailyCalorieGoal * 7

  List<int> weeklyCalories = List.filled(7, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeStats();
  }

  Future<void> _initializeStats() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Önce dailyCalorie hedefini çek
    await _fetchDailyCalorieGoal(userId);
    
    await _clearIfNewWeek(userId);
    final stats = await _fetchWeeklyStats(userId);
    setState(() {
      weeklyCalories = stats;
      isLoading = false;
    });
  }

  Future<void> _fetchDailyCalorieGoal(String userId) async {
    try {
      // En son kaydedilen calorieInfo'yu bul
      final calorieInfoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('calorieInfo')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (calorieInfoSnapshot.docs.isNotEmpty) {
        final latestCalorieInfo = calorieInfoSnapshot.docs.first.data();
        final fetchedDailyCalorie = latestCalorieInfo['dailyCalorie'] ?? 2000;
        
        setState(() {
          dailyCalorieGoal = fetchedDailyCalorie;
          weeklyCalorieGoal = dailyCalorieGoal * 7;
        });
      } else {
        // Eğer calorieInfo yoksa bugünün tarihine bak
        String todayDocId = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final todayCalorieDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('calorieInfo')
            .doc(todayDocId)
            .get();

        if (todayCalorieDoc.exists) {
          final todayData = todayCalorieDoc.data();
          final fetchedDailyCalorie = todayData?['dailyCalorie'] ?? 2000;
          
          setState(() {
            dailyCalorieGoal = fetchedDailyCalorie;
            weeklyCalorieGoal = dailyCalorieGoal * 7;
          });
        }
      }
    } catch (e) {
      print('Günlük kalori hedefi çekilirken hata: $e');
      // Hata durumunda varsayılan değerler kalacak
    }
  }

  Future<void> _clearIfNewWeek(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('lastReset');

    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final thisWeekKey = DateFormat('yyyy-MM-dd').format(monday);

    if (lastReset != thisWeekKey) {
      final mealStatsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('meal_stats');

      final snapshot = await mealStatsRef.get();
      final batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      await prefs.setString('lastReset', thisWeekKey);
    }
  }

  Future<List<int>> _fetchWeeklyStats(String userId) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    List<int> caloriesPerDay = [];

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('meal_stats')
              .doc(dateKey)
              .get();

      if (docSnapshot.exists &&
          docSnapshot.data()!.containsKey('totalCalories')) {
        caloriesPerDay.add(docSnapshot['totalCalories']);
      } else {
        caloriesPerDay.add(0);
      }
    }

    return caloriesPerDay;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final now = DateTime.now();
    int total = weeklyCalories.fold(0, (sum, val) => sum + val);
    double avg = total / 7;

    List<double> cappedCalories =
        weeklyCalories
            .map(
              (val) =>
                  val > dailyCalorieGoal
                      ? dailyCalorieGoal.toDouble()
                      : val.toDouble(),
            )
            .toList();

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        title: Text(AppLocalizations.of(context)!.weeklyStatistics),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              AspectRatio(
                aspectRatio: 1.4,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: dailyCalorieGoal.toDouble(), // VT'den gelen değer
                    minY: 0,
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = [
                              AppLocalizations.of(context)!.mon,
                              AppLocalizations.of(context)!.tue,
                              AppLocalizations.of(context)!.wed,
                              AppLocalizations.of(context)!.thu,
                              AppLocalizations.of(context)!.fri,
                              AppLocalizations.of(context)!.sat,
                              AppLocalizations.of(context)!.sun,
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups:
                        cappedCalories.asMap().entries.map((entry) {
                          final index = entry.key;
                          final cappedValue = entry.value;
                          final isToday = index == now.weekday - 1;

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: cappedValue,
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors:
                                      isToday
                                          ? [
                                            Colors.blue.shade100,
                                            Colors.blue.shade900,
                                          ]
                                          : [
                                            Colors.green.shade100,
                                            Colors.green.shade900,
                                          ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                width: 22,
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: dailyCalorieGoal.toDouble(), // VT'den gelen hedef
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastOutSlowIn,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!.totalWeeklyCalories +
                    ": $total kcal",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.dailyAverage +
                    ": ${avg.toStringAsFixed(0)} kcal",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.target +
                      "$weeklyCalorieGoal" + // VT'den gelen dailyCalorie * 7
                      " kcal / " +
                      AppLocalizations.of(context)!.week,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
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