import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/utils/bmi_utils.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class BodyMassIndexPage extends StatefulWidget {
  const BodyMassIndexPage({super.key});

  @override
  State<BodyMassIndexPage> createState() => _BodyMassIndexPageState();
}

class _BodyMassIndexPageState extends State<BodyMassIndexPage> {
  double? _bmi;
  String? _category;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBMI();
  }

  Future<void> _loadBMI() async {
    final bmi = await calculateBMIFromFirestore();
    if (!mounted) return;
    setState(() {
      _bmi = bmi;
      _category = bmi != null ? bmiCategory(bmi) : null;
      _loading = false;
    });
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case "Zayıf":
        return Colors.blue;
      case "Normal":
        return Colors.green;
      case "Fazla Kilolu":
        return Colors.orange;
      case "Obez":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: MyAppIcons.backIcon,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.bodyMassIndex,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bmi == null
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.pleaseEnterHeightAndWeight,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        color: isDark ? Colors.white : const Color(0xfff7f2fa),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .yourBodyMassIndex,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!
                                    .itiscalculatedaccordingtoyourheightandweightvalues,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${_bmi!.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: getCategoryColor(_category!),
                                    ),
                                  ),
                                  const Text(
                                    "  kg/m²",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _category!,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: getCategoryColor(_category!),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Card(
                        color: const Color(0xfff7f2fa),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.bMICategories,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildRow(Icons.circle_sharp, Colors.blue,
                                  AppLocalizations.of(context)!.underweight, "< 18.5"),
                              _buildRow(Icons.circle_sharp, Colors.green,
                                  AppLocalizations.of(context)!.normal, "18.5 - 24.9"),
                              _buildRow(Icons.circle_sharp, Colors.orange,
                                  AppLocalizations.of(context)!.overweight, "25 - 29.9"),
                              _buildRow(Icons.circle_sharp, Colors.red,
                                  AppLocalizations.of(context)!.obese, "≥ 30"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildRow(IconData iconData, Color color, String label, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(iconData, color: color),
          Text(" $label", style: const TextStyle(color: Colors.black)),
          const Spacer(),
          Text(range, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
