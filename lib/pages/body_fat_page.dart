import 'package:flutter/material.dart'; 
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/models/user_model.dart';
import 'package:flutter_smart_diet_app/utils/body_fat_utils.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class BodyFatPage extends StatelessWidget {
  final UserModel user;

  const BodyFatPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Gerekli değerlerin kontrolü
    if (!isDataValid(user)) {
      return _buildErrorPage(context);
    }

    final double bodyFat = calculateBodyFat(user);
    final String category = getBodyFatCategory(bodyFat, user.gender);
    final Color color = getBodyFatColor(category);

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
        centerTitle: true,
        leading: IconButton(
          icon: MyAppIcons.backIcon,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.bodyFatPercentage,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Debug bilgisi (geliştirme aşamasında)
            if (user.neck == null || user.waist == null || (user.gender == Gender.female && user.hip == null))
              Card(
                color: Colors.orange[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Debug: neck=${user.neck}, waist=${user.waist}, hip=${user.hip}, height=${user.height}, weight=${user.weight}',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ),
            // Üst bilgi kartı
            Card(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xfff7f2fa),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourBodyFatPercentage,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.itiscalculatedbasedonyourheightweightneckwaistandhip,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${bodyFat.toStringAsFixed(1)}",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          " %",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category,
                      style: TextStyle(fontSize: 20, color: color),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Kategori kartı (cinsiyete göre değişiyor)
            Card(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xfff7f2fa),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                            context,
                          )!.bodyFatPercentageCategories +
                          "(${user.gender == Gender.male ? AppLocalizations.of(context)!.male : AppLocalizations.of(context)!.female}):",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(user.gender == Gender.male
                        ? [
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.blue),
                            " " + AppLocalizations.of(context)!.essentialOil,
                            "2-5%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.green),
                            " " + AppLocalizations.of(context)!.athlete,
                            "6-13%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.teal),
                            " " + AppLocalizations.of(context)!.fit,
                            "14-17%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.orange),
                            " " + AppLocalizations.of(context)!.average,
                            "18-24%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.red),
                            " " + AppLocalizations.of(context)!.high,
                            "≥ 25%",
                          ),
                        ]
                        : [
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.blue),
                            " " + AppLocalizations.of(context)!.essentialOil,
                            "10-13%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.green),
                            " " + AppLocalizations.of(context)!.athlete,
                            "14-20%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.teal),
                            " " + AppLocalizations.of(context)!.fit,
                            "21-24%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.orange),
                            " " + AppLocalizations.of(context)!.average,
                            "25-31%",
                          ),
                          _buildRow(
                            Icon(Icons.circle_sharp, color: Colors.red),
                            " " + AppLocalizations.of(context)!.high,
                            "≥ 32%",
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPage(BuildContext context) {
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
        centerTitle: true,
        leading: IconButton(
          icon: MyAppIcons.backIcon,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.bodyFatPercentage,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Card(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xfff7f2fa),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 64),
                SizedBox(height: 16),
                Text(
                  'Eksik Bilgiler',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Vücut yağ oranını hesaplamak için gerekli ölçümler eksik.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(height: 16),
                Text(
                  'Gerekli ölçümler:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Boy\n• Kilo\n• Boyun çevresi\n• Bel çevresi${user.gender == Gender.female ? '\n• Kalça çevresi' : ''}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(Icon icon, String label, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          icon,
          Text(label, style: const TextStyle(color: Colors.black)),
          Spacer(),
          Row(
            children: [
              Text(
                range,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}