import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/tts_service.dart';
import '../widgets/app_scaffold.dart';

/// नोट्सची रचना (९ विभाग). मजकूर शिक्षकाने Firestore 'notes' मधून भरायचा आहे;
/// येथे फक्त मांडणीचा साचा आहे, त्यामुळे अधिकृत नोट्स उपलब्ध नसल्यास रिकाम्या दाखवल्या जातात.
class NotesScreen extends StatelessWidget {
  final Subject subject;
  final String title;
  const NotesScreen({super.key, required this.subject, required this.title});

  static const sections = <(String, String)>[
    ('📘 संकल्पना नोट्स', 'concept'),
    ('🧸 सोप्या भाषेत स्पष्टीकरण', 'easy'),
    ('👩‍🏫 शिक्षक टिप्स', 'teacherTips'),
    ('✨ युक्त्या (Tricks)', 'tricks'),
    ('🧩 स्मरणसूत्र (Mnemonic)', 'mnemonic'),
    ('🎯 परीक्षा टिप्स', 'examTips'),
    ('⚠️ सामान्य चुका', 'commonMistakes'),
    ('⚡ झटपट उजळणी', 'quickRevision'),
    ('🃏 फ्लॅशकार्ड्स', 'flashcards'),
  ];

  @override
  Widget build(BuildContext context) {
    final isEnglish = subject.id == 'en';
    return AppScaffold(
      title: 'नोट्स',
      actions: [
        IconButton(
          tooltip: 'ऐका',
          icon: const Icon(Icons.volume_up),
          onPressed: () => TtsService.speak(title, english: isEnglish),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final s in sections)
            Card(
              child: ExpansionTile(
                title: Text(s.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('या विभागाचा मजकूर लवकरच जोडला जाईल (ॲडमिन पॅनेलमधून भरा).'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
