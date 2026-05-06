import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/pages/auth_wrapper.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 80,
          color: MyAppColors.primaryColor,
        ),
      ),
    );
  }
}
