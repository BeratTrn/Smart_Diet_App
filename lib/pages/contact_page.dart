import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<String?> getUserFullName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      final name = doc['name'] ?? '';
      final surname = doc['surname'] ?? '';
      return '$name $surname';
    } else {
      return null;
    }
  }

   Future<String?> getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      return doc['email'];
    } else {
      return null;
    }
  }

  Future<void> sendEmail() async {
    const serviceId = 'service_07kffzv';
    const templateId = 'template_2kzaykp';
    const publicKey = '2JXPxnymv1bZ-H7a1';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          "email": await getUserEmail(),
          "name": await getUserFullName(),
          'title': _titleController.text,
          'subject': _subjectController.text,
          'message': _messageController.text,
        },
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mesaj başarıyla gönderildi')));
      _titleController.clear();
      _subjectController.clear();
      _messageController.clear();
    } else {
      print('Email gönderilemedi: ${response.body}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mesaj gönderilemedi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> topics = [
      AppLocalizations.of(context)!.generalFeedback,
      AppLocalizations.of(context)!.suggestion,
      AppLocalizations.of(context)!.errorReporting,
      AppLocalizations.of(context)!.supportRequest,
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: MyAppIcons.backIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.contactFeedback,

          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.sendFeedback,

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value:
                        _subjectController.text.isEmpty
                            ? null
                            : _subjectController.text,
                    decoration: InputDecoration(
                      
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: MyAppColors.primaryColor),
                      ),
                      hintText: AppLocalizations.of(context)!.subject,

                      hintStyle: TextStyle(color: Colors.black),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    items:
                        topics.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _subjectController.text = newValue;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.pleasechooseatopic,
                            ),
                          ),
                        );
                      }
                    },
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? AppLocalizations.of(
                                  context,
                                )!.pleasechooseatopic
                                : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: MyAppColors.primaryColor,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: MyAppColors.primaryColor),
                      ),
                      labelText: AppLocalizations.of(context)!.shorttitle,
                    ),
                    validator:
                        (val) =>
                            val!.isEmpty
                                ? AppLocalizations.of(
                                  context,
                                )!.pleaseenteratitle
                                : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: MyAppColors.primaryColor,
                      ),

                      labelText: AppLocalizations.of(context)!.yourmessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: MyAppColors.primaryColor),
                      ),
                    ),
                    maxLines: 5,
                    validator:
                        (val) =>
                            val!.isEmpty
                                ? AppLocalizations.of(context)!.writeyourmessage
                                : null,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendEmail();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: Text(
                      AppLocalizations.of(context)!.submit,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),
            const SizedBox(height: 20),

            Text(
              AppLocalizations.of(context)!.contactInformation,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Image.asset(
                  "assets/images/linkedin.png",
                  width: 21,
                  height: 19,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final Uri linkedinUrl = Uri.parse(
                      "https://www.linkedin.com/in/berat-turan-471bb3299",
                    );

                    if (!await launchUrl(
                      linkedinUrl,
                      mode: LaunchMode.externalApplication,
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("URL açılamadı")),
                      );
                    }
                  },

                  child: Text(
                    'Berat Turan',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Image.asset(
                  "assets/icons/icon_mail.gif",
                  width: 22,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8),
                const Text(
                  "smartdietapp@gmail.com",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Image.asset(
                  "assets/images/icon_phone.png",
                  width: 22,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8),
                const Text("+90 546 780 84 46", style: TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
