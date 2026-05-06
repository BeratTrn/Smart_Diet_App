import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_diet_app/l10n/app_localizations.dart';
import 'package:flutter_smart_diet_app/utils/constans.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<MealNote> notes = [];
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = true; // State başına eklenecek

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('notes')
            .orderBy('timestamp', descending: true)
            .get();

    setState(() {
      notes.clear();
      notes.addAll(
        snapshot.docs.map(
          (doc) => MealNote(
            id: doc.id,
            mealType: doc['mealType'],
            note: doc['note'],
          ),
        ),
      );
      isLoading = false; // Veriler geldikten sonra false yapılır
    });
  }

  Future<void> _addNoteToFirestore(
    String meal,
    String note,
  ) async {
    if (user == null) return;

    final newNoteRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('notes')
        .add({
          'mealType': meal,
          'note': note,
          'timestamp': FieldValue.serverTimestamp(),
        });

    setState(() {
      notes.insert(
        0,
        MealNote(id: newNoteRef.id, mealType: meal, note: note),
      );
    });
  }

  Future<void> _deleteNote(String id) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('notes')
        .doc(id)
        .delete();

    setState(() {
      notes.removeWhere((note) => note.id == id);
    });
  }

  void _addNoteDialog() {
    TextEditingController mealCtrl = TextEditingController();
    TextEditingController noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.addNote),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: mealCtrl,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: MyAppColors.primaryColor),
                    ),
                    hintText: "Öğün (örn. Kahvaltı)",
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: noteCtrl,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: MyAppColors.primaryColor),
                    ),
                    hintText: "Not",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _addNoteToFirestore(
                    mealCtrl.text,
                    noteCtrl.text,
                    
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.add,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📝 ${AppLocalizations.of(context)!.myNotes}"),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: MyAppColors.primaryColor,
                ),
              )
              : notes.isEmpty
              ? const Center(child: Text("Henüz not yok."))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final item = notes[index];
                    return ListTile(
                      title: Text("${item.mealType}"),
                      subtitle: Text(item.note),
                      trailing: IconButton(
                        onPressed: () => _deleteNote(item.id),
                        icon: const Icon(
                          Icons.delete_forever,
                          size: 28,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _addNoteDialog,
        child: const Icon(Icons.note_add, color: Colors.white),
      ),
    );
  }
}

class MealNote {
  final String id;
  final String mealType;
  final String note;

  MealNote({
    required this.id,
    required this.mealType,
    required this.note,
  });
}
