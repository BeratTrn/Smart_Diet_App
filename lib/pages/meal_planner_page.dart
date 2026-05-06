import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  DateTime selectedDate = DateTime.now();
  Map<String, String> mealPlanForSelectedDate = {};
  bool isLoading = true;

  List<String> get mealTypes => [
        AppLocalizations.of(context)!.breakfast,
        AppLocalizations.of(context)!.lunch,
        AppLocalizations.of(context)!.dinner,
        AppLocalizations.of(context)!.snack,
      ];

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  @override
  void initState() {
    super.initState();
    _fetchMealPlan();
  }

  Future<void> _fetchMealPlan() async {
    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dateKey = _formatDate(selectedDate);
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("meal_plans")
        .doc(dateKey)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      mealPlanForSelectedDate = {
        for (var meal in mealTypes)
          meal: (data[meal] ?? "").toString(),
      };
    } else {
      mealPlanForSelectedDate = {
        for (var meal in mealTypes) meal: "",
      };
    }

    setState(() => isLoading = false);
  }

  Future<void> _saveMealToFirestore(String mealType, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dateKey = _formatDate(selectedDate);
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("meal_plans")
        .doc(dateKey);

    await docRef.set(
      {
        mealType: content,
        "updatedAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  void _showMealEditDialog(String mealType) {
    final controller = TextEditingController(
      text: mealPlanForSelectedDate[mealType] ?? "",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mealType ${AppLocalizations.of(context)!.addMeal}"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.egOatmealBanana,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                mealPlanForSelectedDate[mealType] = controller.text;
              });
              await _saveMealToFirestore(mealType, controller.text);
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateKey = _formatDate(selectedDate);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: MyAppIcons.backIcon,
        ),
        title: Row(
          children: [
            Image.asset("assets/images/calendar.png", width: 20, height: 17),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.mealPlanner),
          ],
        ),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
              });
              _fetchMealPlan();
            },
          ),
          isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: mealTypes.length,
                    itemBuilder: (context, index) {
                      final mealType = mealTypes[index];
                      final content = mealPlanForSelectedDate[mealType] ?? "";

                      return ListTile(
                        leading: Icon(Icons.restaurant,
                            color: Colors.blue.shade400),
                        title: Text(mealType,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          content.isNotEmpty
                              ? content
                              : AppLocalizations.of(context)!.notyetplanned,
                        ),
                        trailing: IconButton(
                          icon: MyAppIcons.editIcon,
                          onPressed: () => _showMealEditDialog(mealType),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
