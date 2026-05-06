import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/models/user_model.dart';

/// Kullanıcının vücut yağ oranını hesaplar (US Navy Body Fat Formula kullanarak)
double calculateBodyFat(UserModel user) {
  try {
    // Null kontrolü
    if (!isDataValid(user)) {
      return 0.0;
    }

    // Değerleri cm cinsinden al (eğer metre cinsindeyse çevir)
    double height = user.height!;
    double neck = user.neck!;
    double waist = user.waist!;
    
  

    if (user.gender == Gender.male) {
      // Erkekler için US Navy formülü
      double bodyFat = 495 /
              (1.0324 -
                  0.19077 * log(waist - neck) / ln10 +
                  0.15456 * log(height) / ln10) -
          450;
      
      // Sonucu mantıklı aralıkta tut
      return _clampBodyFat(bodyFat);
    } else {
      // Kadınlar için hip değeri gerekli
      if (user.hip == null) {
        return 0.0;
      }
      
      double hip = user.hip!;
      
      // Kadınlar için US Navy formülü
      double bodyFat = 495 /
              (1.29579 -
                  0.35004 * log(waist + hip - neck) / ln10 +
                  0.22100 * log(height) / ln10) -
          450;
      
      // Sonucu mantıklı aralıkta tut
      return _clampBodyFat(bodyFat);
    }
  } catch (e) {
    print('Body fat hesaplama hatası: $e');
    return 0.0;
  }
}


/// Vücut yağ oranını mantıklı aralıkta tutar
double _clampBodyFat(double bodyFat) {
  // Gerçekten geçersiz bir değer geldiyse sıfırla
  if (bodyFat <= 0 || bodyFat.isNaN) return 0.0;

  if (bodyFat < 2) return 2.0;
  
  return bodyFat;
}

/// Gerekli verilerin mevcut olup olmadığını kontrol eder
bool isDataValid(UserModel user) {
  // Temel veriler
  if (user.height == null || user.weight == null) {
    return false;
  }
  
  // US Navy formülü için gerekli ölçümler
  if (user.neck == null || user.waist == null) {
    return false;
  }
  
  // Kadınlar için kalça ölçümü gerekli
  if (user.gender == Gender.female && user.hip == null) {
    return false;
  }
  
  // Değerlerin mantıklı olup olmadığını kontrol et
  if (user.neck! <= 0 || user.waist! <= 0) {
    return false;
  }
  
  if (user.gender == Gender.female && user.hip! <= 0) {
    return false;
  }
  
  return true;
}

/// Vücut yağ oranına göre kategori belirler
String getBodyFatCategory(double fatPercent, Gender gender) {
  if (fatPercent <= 0) return "Veri Yetersiz";
  
  if (gender == Gender.male) {
    if (fatPercent <= 5) return "Temel Yağ";
    if (fatPercent <= 13) return "Sporcu";
    if (fatPercent <= 17) return "Fit";
    if (fatPercent <= 24) return "Ortalama";
    return "Yüksek";
  } else {
    if (fatPercent <= 13) return "Temel Yağ";
    if (fatPercent <= 20) return "Sporcu";
    if (fatPercent <= 24) return "Fit";
    if (fatPercent <= 31) return "Ortalama";
    return "Yüksek";
  }
}

/// Kategoriye göre renk döndürür
Color getBodyFatColor(String category) {
  switch (category) {
    case "Temel Yağ":
      return Colors.blue;
    case "Sporcu":
      return Colors.green;
    case "Fit":
      return Colors.teal;
    case "Ortalama":
      return Colors.orange;
    case "Yüksek":
      return Colors.red;
    case "Veri Yetersiz":
      return Colors.grey;
    default:
      return Colors.black;
  }
}

/// Sağlık önerileri döndürür
String getBodyFatAdvice(double fatPercent, Gender gender) {
  String category = getBodyFatCategory(fatPercent, gender);
  
  switch (category) {
    case "Temel Yağ":
      return "Vücut yağ oranınız çok düşük. Sağlık açısından tehlikeli olabilir.";
    case "Sporcu":
      return "Mükemmel! Sporcu seviyesinde vücut yağ oranına sahipsiniz.";
    case "Fit":
      return "Harika! Fit ve sağlıklı bir vücut yağ oranınız var.";
    case "Ortalama":
      return "Ortalama seviyede. Biraz egzersiz ile iyileştirilebilir.";
    case "Yüksek":
      return "Vücut yağ oranınız yüksek. Diyet ve egzersize odaklanmalısınız.";
    default:
      return "Hesaplama için yeterli veri yok.";
  }
}