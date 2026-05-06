import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/pages/home_page.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String name,
      surname,
      email,
      age,
      height,
      weight,
      waist,
      neck,
      hip,
      gender;

  EmailVerificationScreen({
    required this.name,
    required this.surname,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.waist,
    required this.neck,
    required this.hip,
    required this.gender,
  });

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': widget.name,
        'surname': widget.surname,
        'email': widget.email,
        'age': int.parse(widget.age),
        'height': double.parse(widget.height),
        'weight': double.parse(widget.weight),
        'waist': double.parse(widget.waist),
        'neck': double.parse(widget.neck),
        'hip': double.parse(widget.hip),
        'gender': widget.gender,
        'createdAt': Timestamp.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      // bekleme ekranı
      await Future.delayed(Duration(seconds: 3));
      checkEmailVerification(); // tekrar kontrol et
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Lütfen e-posta adresinizi doğrulayın...")),
    );
  }
}
