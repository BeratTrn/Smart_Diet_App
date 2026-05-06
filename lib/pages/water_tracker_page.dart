import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  int waterCups = 0;
  final int goal = 10;

  @override
  void initState() {
    super.initState();
    _loadWaterData();
  }

  // Gün kontrolünü build sonrasında da tetikle
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadWaterData(); // Gün değişmişse sıfırla
  }

  int get estimatedHydrationCalories => waterCups * 25;

  Future<void> _loadWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('lastDate');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (storedDate == today) {
      setState(() {
        waterCups = prefs.getInt('waterCups') ?? 0;
      });
    } else {
      await prefs.setString('lastDate', today);
      await prefs.setInt('waterCups', 0);
      setState(() {
        waterCups = 0;
      });
      await _updateStatsInFirestore();
    }
  }

  Future<void> _saveWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterCups', waterCups);
    await prefs.setString(
      'lastDate',
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    await _updateStatsInFirestore();
  }

  Future<void> _updateStatsInFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('meal_stats')
        .doc(dateKey);

    final snapshot = await docRef.get();
    if (snapshot.exists) {
      await docRef.update({'hydrationCalories': estimatedHydrationCalories});
    } else {
      await docRef.set({
        'hydrationCalories': estimatedHydrationCalories,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _incrementWater() {
    if (waterCups < goal) {
      setState(() => waterCups++);
      _saveWaterData();
    }
  }

  void _decrementWater() {
    if (waterCups > 0) {
      setState(() => waterCups--);
      _saveWaterData();
    }
  }

  Color getDynamicColor(double percent) {
    return Color.lerp(
      Colors.lightBlue.shade200,
      Colors.blue,
      percent.clamp(0.0, 1),
    )!;
  }

  @override
  Widget build(BuildContext context) {
    double percent = waterCups / goal;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.waterTracking,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 16.0,
              animateFromLastPercent: true,
              percent: percent > 1 ? 1 : percent,
              animation: true,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$waterCups / $goal",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(AppLocalizations.of(context)!.glasses),
                ],
              ),
              progressColor: getDynamicColor(percent),
              backgroundColor: Colors.grey.shade200,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 30),
            Text(
              AppLocalizations.of(context)!.dailyWaterGoal,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrementWater,
                  icon: const Icon(Icons.remove),
                  label: Text(AppLocalizations.of(context)!.subtract),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade900,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _incrementWater,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orange.shade700,
                      size: 36,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "${AppLocalizations.of(context)!.hydrationImpact}: +$estimatedHydrationCalories kcal",
                        style: TextStyle(
                          color: isDark ? Colors.black : Colors.grey[150],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Opacity(
              opacity: percent == 1.0 ? 1 : 0.5,
              child: Text(
                percent == 1.0
                    ? AppLocalizations.of(context)!.goalCompleted
                    : AppLocalizations.of(context)!.keepGoing,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
