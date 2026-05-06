import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : MyAppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : MyAppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.about,
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: MyAppIcons.backIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
          child: Card(
            elevation: 15,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyAppIcons.infoIcon,
                      SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.aboutTheApp,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(
                      context,
                    )!.smartDietAppIsSmartDietAppDevelopedForUsers,
                  ),
                  Text(AppLocalizations.of(context)!.thanksToThisApp),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/dark_dinner.png",
                        height: 17,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.youCanEasilyRecordYourmealsaccordingtoyourdailymeals,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/light_dark_fire.png",
                        height: 17,

                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.youcaninstantlytrackcaloriesproteincarbohydratesandfatlevels,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/light_dark_analysis.png",
                        height: 17,

                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.youcanseeyourweeklystatisticswithgraphs,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/light_dark_water-drop.png",
                        height: 17,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.youcanmarkyourdailywaterconsumption,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/light_dark_target.png",
                        height: 17,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.youcanincreaseyourmotivationbysettingyourowngoals,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.italSocalCulatesImportantHealthValuesSuchasBodyMassIndex,
                  ),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.itmakestrackingyournutritioneasierthankstoitsmodernanduser,
                  ),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.smartDietAppisdesignedtohelpyoumakehealthyliving,
                  ),

                  Text(
                    AppLocalizations.of(
                      context,
                    )!.startnowandachieveyourgoalssmartly,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    AppLocalizations.of(context)!.version + " 1.0.0",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
