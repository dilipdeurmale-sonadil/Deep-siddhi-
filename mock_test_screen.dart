import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/syllabus_data.dart';
import '../services/app_state.dart';
import '../services/question_repository.dart';
import '../widgets/app_scaffold.dart';
import 'quiz_screen.dart';

class MockTestScreen extends StatelessWidget {
  const MockTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    void start(String title, String? subjectId) {
      final qs = (subjectId == null ? QuestionRepository.allForGrade(s.grade) : QuestionRepository.bySubject(s.grade, subjectId))..shuffle();
      if (qs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('प्रश्न लवकरच जोडले जातील.')));
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuizScreen(title: title, questions: qs)));
    }

    return AppScaffold(
      title: 'मॉक टेस्ट',
      body: ListView(padding: const EdgeInsets.all(12), children: [
        Card(
          child: ListTile(
            leading: const Text('🏁', style: TextStyle(fontSize: 28)),
            title: const Text('संपूर्ण शिष्यवृत्ती टेस्ट', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('सर्व विषय, प्रत्येक प्रश्नाला ३० सेकंद'),
            onTap: () => start('संपूर्ण टेस्ट', null),
          ),
        ),
        for (final sub in SyllabusData.forGrade(s.grade))
          Card(
            child: ListTile(
              leading: Text(sub.emoji, style: const TextStyle(fontSize: 28)),
              title: Text('${sub.nameMr} - विषयनिहाय टेस्ट'),
              onTap: () => start(sub.nameMr, sub.id),
            ),
          ),
      ]),
    );
  }
}
