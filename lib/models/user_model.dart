enum Gender { male, female }

class UserModel {
  final String name;
  final String surname;
  final String email;
  final int age;
  final double weight;
  final double height;
  final double waist;
  final double neck;
  final double hip;
  final Gender gender;
  final String? avatar;

  UserModel({
    required this.name,
    required this.surname,
    required this.email,
    required this.age,
    required this.weight,
    required this.height,
    required this.waist,
    required this.neck,
    required this.hip,
    required this.gender,
    this.avatar,
  });

  String get genderText {
    switch (gender) {
      case Gender.male:
        return 'Erkek';
      case Gender.female:
        return 'Kadın';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      "surname": surname,
      'email': email,
      'age': age,
      'weight': weight,
      'height': height,
      'waist': waist,
      'neck': neck,
      'hip': hip,
      'gender': gender == Gender.male ? 'Erkek' : 'Kadın',
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      email: map['email'] ?? '',
      age: int.tryParse(map['age'].toString()) ?? 0,
      weight: double.tryParse(map['weight'].toString()) ?? 0.0,
      height: double.tryParse(map['height'].toString()) ?? 0.0,
      waist: double.tryParse(map['waist'].toString()) ?? 0.0,
      neck: double.tryParse(map['neck'].toString()) ?? 0.0,
      hip: double.tryParse(map['hip'].toString()) ?? 0.0,
      gender: (map['gender'] == 'Erkek') ? Gender.male : Gender.female,
      avatar: map['avatar'],
    );
  }
}
