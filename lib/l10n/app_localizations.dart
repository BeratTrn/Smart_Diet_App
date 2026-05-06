import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('pt'),
    Locale('tr')
  ];

  /// No description provided for @pleaseEnterHeightAndWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your height and weight information.'**
  String get pleaseEnterHeightAndWeight;

  /// No description provided for @pleasedonotleavethisfieldblank.
  ///
  /// In en, this message translates to:
  /// **'Please do not leave this field blank'**
  String get pleasedonotleavethisfieldblank;

  /// No description provided for @passwordRenewal.
  ///
  /// In en, this message translates to:
  /// **'Password Renewal'**
  String get passwordRenewal;

  /// No description provided for @namesurname.
  ///
  /// In en, this message translates to:
  /// **'Name-Surname'**
  String get namesurname;

  /// No description provided for @mealPlanner.
  ///
  /// In en, this message translates to:
  /// **'Meal Planner'**
  String get mealPlanner;

  /// No description provided for @notyetplanned.
  ///
  /// In en, this message translates to:
  /// **'Not yet planned'**
  String get notyetplanned;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get addMeal;

  /// No description provided for @egOatmealBanana.
  ///
  /// In en, this message translates to:
  /// **'E.g., Oatmeal + Banana'**
  String get egOatmealBanana;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @dateEg.
  ///
  /// In en, this message translates to:
  /// **'Date (e.g., 2025-07-21)'**
  String get dateEg;

  /// No description provided for @mealEg.
  ///
  /// In en, this message translates to:
  /// **'Meal (e.g., Breakfast)'**
  String get mealEg;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @myNotes.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get myNotes;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target: '**
  String get target;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @hydrationImpact.
  ///
  /// In en, this message translates to:
  /// **'Hydration Boost'**
  String get hydrationImpact;

  /// No description provided for @goalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Goal Completed 🎉'**
  String get goalCompleted;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Go ahead, don\'t forget to drink water!'**
  String get keepGoing;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePage;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutTheApp;

  /// No description provided for @smartDietAppIsSmartDietAppDevelopedForUsers.
  ///
  /// In en, this message translates to:
  /// **'Smart Diet App is a smart diet app developed for users who aim for a healthy lifestyle, allowing you to track your personal nutrition and health'**
  String get smartDietAppIsSmartDietAppDevelopedForUsers;

  /// No description provided for @thanksToThisApp.
  ///
  /// In en, this message translates to:
  /// **'Thanks to this app:'**
  String get thanksToThisApp;

  /// No description provided for @youCanEasilyRecordYourmealsaccordingtoyourdailymeals.
  ///
  /// In en, this message translates to:
  /// **'You can easily record your meals according to your daily meals'**
  String get youCanEasilyRecordYourmealsaccordingtoyourdailymeals;

  /// No description provided for @youcaninstantlytrackcaloriesproteincarbohydratesandfatlevels.
  ///
  /// In en, this message translates to:
  /// **'You can instantly track calories, protein, carbohydrates and fat levels'**
  String get youcaninstantlytrackcaloriesproteincarbohydratesandfatlevels;

  /// No description provided for @youcanseeyourweeklystatisticswithgraphs.
  ///
  /// In en, this message translates to:
  /// **'You can see your weekly statistics with graphs'**
  String get youcanseeyourweeklystatisticswithgraphs;

  /// No description provided for @youcanmarkyourdailywaterconsumption.
  ///
  /// In en, this message translates to:
  /// **'You can mark your daily water consumption'**
  String get youcanmarkyourdailywaterconsumption;

  /// No description provided for @youcanincreaseyourmotivationbysettingyourowngoals.
  ///
  /// In en, this message translates to:
  /// **'You can increase your motivation by setting your own goals'**
  String get youcanincreaseyourmotivationbysettingyourowngoals;

  /// No description provided for @italSocalCulatesImportantHealthValuesSuchasBodyMassIndex.
  ///
  /// In en, this message translates to:
  /// **'It also calculates important health values such as body mass index (BMI) and body fat percentage and provides you with personalized feedback'**
  String get italSocalCulatesImportantHealthValuesSuchasBodyMassIndex;

  /// No description provided for @itmakestrackingyournutritioneasierthankstoitsmodernanduser.
  ///
  /// In en, this message translates to:
  /// **'It makes tracking your nutrition easier thanks to its modern and user-friendly interface'**
  String get itmakestrackingyournutritioneasierthankstoitsmodernanduser;

  /// No description provided for @smartDietAppisdesignedtohelpyoumakehealthyliving.
  ///
  /// In en, this message translates to:
  /// **'Smart Diet App is designed to help you make healthy living habits sustainable'**
  String get smartDietAppisdesignedtohelpyoumakehealthyliving;

  /// No description provided for @startnowandachieveyourgoalssmartly.
  ///
  /// In en, this message translates to:
  /// **'Start now and achieve your goals smartly'**
  String get startnowandachieveyourgoalssmartly;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @addFood.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFood;

  /// No description provided for @pleasechooseameal.
  ///
  /// In en, this message translates to:
  /// **'Please choose a meal'**
  String get pleasechooseameal;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'meal'**
  String get meal;

  /// No description provided for @searchforFood.
  ///
  /// In en, this message translates to:
  /// **'Search for Food'**
  String get searchforFood;

  /// No description provided for @selectedMeal.
  ///
  /// In en, this message translates to:
  /// **'Selected Meal'**
  String get selectedMeal;

  /// No description provided for @portiongrams.
  ///
  /// In en, this message translates to:
  /// **'Portion (grams)'**
  String get portiongrams;

  /// No description provided for @calorie.
  ///
  /// In en, this message translates to:
  /// **'Calorie'**
  String get calorie;

  /// No description provided for @nutritionalValues.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Values'**
  String get nutritionalValues;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'protein'**
  String get protein;

  /// No description provided for @carbohydrate.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate'**
  String get carbohydrate;

  /// No description provided for @oil.
  ///
  /// In en, this message translates to:
  /// **'Oil'**
  String get oil;

  /// No description provided for @bodyFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Percentage'**
  String get bodyFatPercentage;

  /// No description provided for @yourBodyFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Your Body Fat Percentage'**
  String get yourBodyFatPercentage;

  /// No description provided for @itiscalculatedbasedonyourheightweightneckwaistandhip.
  ///
  /// In en, this message translates to:
  /// **'It is calculated based on your height, weight, neck, waist and hip measurements'**
  String get itiscalculatedbasedonyourheightweightneckwaistandhip;

  /// No description provided for @bodyFatPercentageCategories.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Percentage Categories'**
  String get bodyFatPercentageCategories;

  /// No description provided for @essentialOil.
  ///
  /// In en, this message translates to:
  /// **'Essential Oil'**
  String get essentialOil;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'female'**
  String get female;

  /// No description provided for @athlete.
  ///
  /// In en, this message translates to:
  /// **'Athlete'**
  String get athlete;

  /// No description provided for @fit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get fit;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @obese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get obese;

  /// No description provided for @bodyMassIndex.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index'**
  String get bodyMassIndex;

  /// No description provided for @yourBodyMassIndex.
  ///
  /// In en, this message translates to:
  /// **'Your Body Mass Index'**
  String get yourBodyMassIndex;

  /// No description provided for @itiscalculatedaccordingtoyourheightandweightvalues.
  ///
  /// In en, this message translates to:
  /// **'It is calculated according to your height and weight values'**
  String get itiscalculatedaccordingtoyourheightandweightvalues;

  /// No description provided for @bMICategories.
  ///
  /// In en, this message translates to:
  /// **'BMI Categories'**
  String get bMICategories;

  /// No description provided for @calorieNeeds.
  ///
  /// In en, this message translates to:
  /// **'Calorie Needs'**
  String get calorieNeeds;

  /// No description provided for @yourDailyCalorieNeeds.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Calorie Needs'**
  String get yourDailyCalorieNeeds;

  /// No description provided for @calculatedbasedonyourheightweightageandactivitylevel.
  ///
  /// In en, this message translates to:
  /// **'Calculated based on your height, weight, age and activity level'**
  String get calculatedbasedonyourheightweightageandactivitylevel;

  /// No description provided for @basalMetabolicRate.
  ///
  /// In en, this message translates to:
  /// **'Basal Metabolic Rate'**
  String get basalMetabolicRate;

  /// No description provided for @dailyCalorieNeeds.
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Needs'**
  String get dailyCalorieNeeds;

  /// No description provided for @accordingtoYourGoals.
  ///
  /// In en, this message translates to:
  /// **'According to Your Goals'**
  String get accordingtoYourGoals;

  /// No description provided for @loseweight.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get loseweight;

  /// No description provided for @maintainingWeight.
  ///
  /// In en, this message translates to:
  /// **'Maintaining Weight'**
  String get maintainingWeight;

  /// No description provided for @gainweight.
  ///
  /// In en, this message translates to:
  /// **'Gain weight'**
  String get gainweight;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @generalFeedback.
  ///
  /// In en, this message translates to:
  /// **'General Feedback'**
  String get generalFeedback;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @errorReporting.
  ///
  /// In en, this message translates to:
  /// **'Error Reporting'**
  String get errorReporting;

  /// No description provided for @supportRequest.
  ///
  /// In en, this message translates to:
  /// **'Support Request'**
  String get supportRequest;

  /// No description provided for @yourfeedbackhasbeensent.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has been sent'**
  String get yourfeedbackhasbeensent;

  /// No description provided for @contactFeedback.
  ///
  /// In en, this message translates to:
  /// **'Contact / Feedback'**
  String get contactFeedback;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @pleasechooseatopic.
  ///
  /// In en, this message translates to:
  /// **'Please choose a topic'**
  String get pleasechooseatopic;

  /// No description provided for @shorttitle.
  ///
  /// In en, this message translates to:
  /// **'Short title'**
  String get shorttitle;

  /// No description provided for @pleaseenteratitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseenteratitle;

  /// No description provided for @yourmessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourmessage;

  /// No description provided for @writeyourmessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message'**
  String get writeyourmessage;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @bodymeasurements.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get bodymeasurements;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @waistcircumference.
  ///
  /// In en, this message translates to:
  /// **'Waist circumference'**
  String get waistcircumference;

  /// No description provided for @neckcircumference.
  ///
  /// In en, this message translates to:
  /// **'Neck circumference'**
  String get neckcircumference;

  /// No description provided for @hipcircumference.
  ///
  /// In en, this message translates to:
  /// **'Hip circumference'**
  String get hipcircumference;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @enteryourregisteredemailaddressApasswordresetcode.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address. A password reset code will be sent to your email address'**
  String get enteryourregisteredemailaddressApasswordresetcode;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @enteryouremailaddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enteryouremailaddress;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @waterTracking.
  ///
  /// In en, this message translates to:
  /// **'Water Tracking'**
  String get waterTracking;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @areyousureyouwanttologout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out'**
  String get areyousureyouwanttologout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @totalCalories.
  ///
  /// In en, this message translates to:
  /// **'Total Calories'**
  String get totalCalories;

  /// No description provided for @yourdailygoal.
  ///
  /// In en, this message translates to:
  /// **'Your daily goal'**
  String get yourdailygoal;

  /// No description provided for @nofoodhasbeenaddedfortoday.
  ///
  /// In en, this message translates to:
  /// **'No food has been added for today'**
  String get nofoodhasbeenaddedfortoday;

  /// No description provided for @thelanguagehasbeenchangedItrequiresyoutorestarttheapplication.
  ///
  /// In en, this message translates to:
  /// **'The language has been changed. It requires you to restart the application'**
  String get thelanguagehasbeenchangedItrequiresyoutorestarttheapplication;

  /// No description provided for @smartDiet.
  ///
  /// In en, this message translates to:
  /// **'Smart Diet'**
  String get smartDiet;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @iforgotmypassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get iforgotmypassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontthaveanaccountSignup.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontthaveanaccountSignup;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @additiontime.
  ///
  /// In en, this message translates to:
  /// **'Addition time'**
  String get additiontime;

  /// No description provided for @deleteFood.
  ///
  /// In en, this message translates to:
  /// **'Delete Food'**
  String get deleteFood;

  /// No description provided for @thefoodwasdeleted.
  ///
  /// In en, this message translates to:
  /// **'the food was deleted'**
  String get thefoodwasdeleted;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editprofile;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @yourCalorieNeeds.
  ///
  /// In en, this message translates to:
  /// **'Your Calorie Needs'**
  String get yourCalorieNeeds;

  /// No description provided for @userSettings.
  ///
  /// In en, this message translates to:
  /// **'User Settings'**
  String get userSettings;

  /// No description provided for @updateProfileInformation.
  ///
  /// In en, this message translates to:
  /// **'Update Profile Information'**
  String get updateProfileInformation;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @accountWillBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account Will Be Deleted'**
  String get accountWillBeDeleted;

  /// No description provided for @areyousureyouwanttodeletetheaccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the account'**
  String get areyousureyouwanttodeletetheaccount;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted'**
  String get accountDeleted;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @turnNotificationsOnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn Notifications On/Off'**
  String get turnNotificationsOnOff;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter Password'**
  String get reenterPassword;

  /// No description provided for @alreadyhaveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get alreadyhaveanaccount;

  /// No description provided for @weeklyStatistics.
  ///
  /// In en, this message translates to:
  /// **'Weekly Statistics'**
  String get weeklyStatistics;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @totalWeeklyCalories.
  ///
  /// In en, this message translates to:
  /// **'Total Weekly Calories'**
  String get totalWeeklyCalories;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @goalkcalweek.
  ///
  /// In en, this message translates to:
  /// **'Goal:  kcal/week'**
  String get goalkcalweek;

  /// No description provided for @changingthethemerequiresrestartingtheapp.
  ///
  /// In en, this message translates to:
  /// **'Changing the theme requires restarting the app'**
  String get changingthethemerequiresrestartingtheapp;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @dailyWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Water Goal'**
  String get dailyWaterGoal;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'Glasses'**
  String get glasses;

  /// No description provided for @subtract.
  ///
  /// In en, this message translates to:
  /// **'Subtract'**
  String get subtract;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'fr', 'pt', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'pt': return AppLocalizationsPt();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
