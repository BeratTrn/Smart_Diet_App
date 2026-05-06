import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/pages/profile_page.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class ProfilePhotoPage extends StatefulWidget {
  @override
  _ProfilePhotoPageState createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> {
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      _avatarPath = doc.data()?['avatar']; // null olabilir
    });
  }

  Future<void> _saveAvatar(String path) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'avatar': path,
    }, SetOptions(merge: true));

    setState(() {
      _avatarPath = path;
    });
  }

  void _showAvatarPicker() {
    List<String> avatars = [
      "assets/images/avatar_kadın1.png",
      "assets/images/avatar_kadın2.png",
      "assets/images/avatar_kadın3.png",
      "assets/images/avatar_erkek1.png",
      "assets/images/avatar_erkek2.png",
      "assets/images/avatar_erkek3.png",
    ];

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: EdgeInsets.all(16),
          itemCount: avatars.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _saveAvatar(avatars[index]);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(avatars[index]),
                radius: 50,
                backgroundColor: Colors.white,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarWidget =
        _avatarPath == null
            ? CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
              backgroundColor: Colors.white,
            )
            : CircleAvatar(
              backgroundImage: AssetImage(_avatarPath!),
              radius: 100,
              backgroundColor: Colors.white,
            );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          icon: MyAppIcons.backIcon,
        ),
        title: Text("Profil Fotoğrafı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            avatarWidget,
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAvatarPicker,
              icon: Icon(Icons.edit, color: MyAppColors.primaryColor, size: 25),
              label: Text(
                "Avatarı Değiştir",
                style: TextStyle(color: MyAppColors.primaryColor, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
