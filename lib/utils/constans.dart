import 'package:flutter/material.dart';

Map<String, Map<String, List<Map<String, dynamic>>>> localMealStorage = {};

class MyAppColors {
  static Color primaryColor = Colors.blue.shade800;
  static Color backgroundColor = Colors.white;
}

class MyAppIcons {
  static Icon breakfast = Icon(Icons.breakfast_dining, color: Colors.orange);
  static Icon lunch = Icon(Icons.lunch_dining, color: Colors.orange);
  static Icon dinner = Icon(Icons.dinner_dining, color: Colors.orange);
  static Icon snack = Icon(Icons.restaurant, color: Colors.orange);
  static Icon backIcon = Icon(Icons.arrow_back_ios);
  static Icon forwardIcon = Icon(
    Icons.arrow_forward_ios,
    color: MyAppColors.primaryColor,
  );
  static Icon closeIcon = Icon(Icons.close, color: MyAppColors.primaryColor);
  static Icon checkIcon = Icon(Icons.check, color: MyAppColors.primaryColor);
  static Icon errorIcon = Icon(Icons.error, color: MyAppColors.primaryColor);
  static Icon warningIcon = Icon(
    Icons.warning,
    color: MyAppColors.primaryColor,
  );
  static Icon statsIcon = Icon(
    Icons.bar_chart,
    color: MyAppColors.primaryColor,
  );
  static Icon waterIcon = Icon(
    Icons.water_drop,
    color: MyAppColors.primaryColor,
  );
  static Icon infoIcon = Icon(Icons.info, color: MyAppColors.primaryColor);
  static Icon menuIcon = Icon(Icons.menu, color: MyAppColors.primaryColor);
  static Icon addIcon = Icon(Icons.add, color: MyAppColors.primaryColor);
  static Icon deleteIcon = Icon(Icons.delete, color: MyAppColors.primaryColor);
  static Icon editIcon = Icon(Icons.edit, color: MyAppColors.primaryColor);
  static Icon searchIcon = Icon(Icons.search, color: MyAppColors.primaryColor);
  static Icon homeIcon = Icon(Icons.home, color: MyAppColors.primaryColor);
  static Icon profileIcon = Icon(Icons.person, color: MyAppColors.primaryColor);
  static Icon settingsIcon = Icon(
    Icons.settings,
    color: MyAppColors.primaryColor,
  );
  static Icon mailIcon = Icon(
    Icons.email_outlined,
    color: MyAppColors.primaryColor,
  );
  static Icon phoneIcon = Icon(Icons.phone, color: MyAppColors.primaryColor);
  static Icon lockIcon = Icon(
    Icons.lock_outline,
    color: MyAppColors.primaryColor,
  );
  static Icon calendarIcon = Icon(
    Icons.calendar_today,
    color: MyAppColors.primaryColor,
  );
  static Icon locationIcon = Icon(
    Icons.location_on,
    color: MyAppColors.primaryColor,
  );
  static Icon cameraIcon = Icon(
    Icons.camera_alt,
    color: MyAppColors.primaryColor,
  );
  static Icon galleryIcon = Icon(
    Icons.photo_library,
    color: MyAppColors.primaryColor,
  );
  static Icon uploadIcon = Icon(
    Icons.upload_file,
    color: MyAppColors.primaryColor,
  );
  static Icon downloadIcon = Icon(
    Icons.download,
    color: MyAppColors.primaryColor,
  );
  static Icon shareIcon = Icon(Icons.share, color: MyAppColors.primaryColor);
  static Icon favoriteIcon = Icon(
    Icons.favorite,
    color: MyAppColors.primaryColor,
  );
  static Icon notificationIcon = Icon(
    Icons.notifications,
    color: MyAppColors.primaryColor,
  );
  static Icon logoutIcon = Icon(Icons.logout, color: Colors.red);
  static Icon loginIcon = Icon(Icons.login, color: MyAppColors.primaryColor);
  static Icon registerIcon = Icon(
    Icons.app_registration,
    color: MyAppColors.primaryColor,
  );
  static Icon passwordIcon = Icon(Icons.lock, color: MyAppColors.primaryColor);
  static Icon termsIcon = Icon(Icons.article, color: MyAppColors.primaryColor);
  static Icon privacyIcon = Icon(
    Icons.privacy_tip,
    color: MyAppColors.primaryColor,
  );
  static Icon helpIcon = Icon(
    Icons.help_outline,
    color: MyAppColors.primaryColor,
  );
  static Icon supportIcon = Icon(
    Icons.support_agent,
    color: MyAppColors.primaryColor,
  );
  static Icon feedbackIcon = Icon(
    Icons.feedback,
    color: MyAppColors.primaryColor,
  );
  static Icon reportIcon = Icon(
    Icons.report_problem,
    color: MyAppColors.primaryColor,
  );
  static Icon languageIcon = Icon(
    Icons.language,
    color: MyAppColors.primaryColor,
  );
  static Icon themeIcon = Icon(
    Icons.brightness_6,
    color: MyAppColors.primaryColor,
  );
  static Icon searchIconFilled = Icon(
    Icons.search,
    color: MyAppColors.primaryColor,
  );
  static Icon filterIcon = Icon(
    Icons.filter_list,
    color: MyAppColors.primaryColor,
  );
  static Icon sortIcon = Icon(Icons.sort, color: MyAppColors.primaryColor);
  static Icon refreshIcon = Icon(
    Icons.refresh,
    color: MyAppColors.primaryColor,
  );
  static Icon visibilityIcon = Icon(
    Icons.visibility,
    color: MyAppColors.primaryColor,
  );
  static Icon visibilityOffIcon = Icon(
    Icons.visibility_off,
    color: MyAppColors.primaryColor,
  );
}
