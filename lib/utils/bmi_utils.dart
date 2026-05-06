import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<double?> calculateBMIFromFirestore() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  final data = doc.data();
  if (data == null || data['weight'] == null || data['height'] == null) {
    return null;
  }

  final double weight = (data['weight'] as num).toDouble();
  final double height = (data['height'] as num).toDouble();

  return weight / ((height / 100) * (height / 100));
}

String bmiCategory(double bmi) {
  if (bmi < 18.5) {
    return "Zayıf";
  } else if (bmi < 25) {
    return "Normal";
  } else if (bmi < 30) {
    return "Fazla Kilolu";
  } else {
    return "Obez";
  }
}
