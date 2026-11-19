import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/question_repository.dart';
import '../widgets/app_scaffold.dart';
import 'notes_screen.dart';
import 'quiz_screen.dart';

class TopicScreen extends StatelessWidget {
  final Subject subject;
  final String topicId;
  final String title;
  const TopicScreen({super.key, required this.subject, required this.topicId, required this.title});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final best = s.topicBest[topicId];

    Widget btn(String label, Color c, VoidCallback f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: c), onPressed: f, child: Text(label)),
          ),
        );

    void practice(int? level) {
      final qs = QuestionRepository.byTopic(s.grade, topicId, level: level)..shuffle();
      if (qs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('या विभागाचे प्रश्न लवकरच जोडले जातील.')),
        );
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => QuizScreen(title: title, topicId: topicId, questions: qs),
      ));
    }

    return AppScaffold(
      title: subject.nameMr,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          if (best != null) Text('तुमचा सर्वोत्तम निकाल: $best%', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          btn('📚 मार्गदर्शन / नोट्स', AppColors.blue, () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => NotesScreen(subject: subject, title: title)))),
          btn('🟢 सराव - पातळी १', AppColors.green, () => practice(1)),
          btn('🟠 सराव - पातळी २', AppColors.orange, () => practice(2)),
          btn('🔴 सराव - पातळी ३', AppColors.red, () => practice(3)),
          btn('🏆 स्कॉलरशिप चॅम्पियन', AppColors.purple, () => practice(4)),
          btn('🎲 सर्व प्रश्न (मिश्र)', AppColors.blue, () => practice(null)),
        ]),
      ),
    );
  }
}
