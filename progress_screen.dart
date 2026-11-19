import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../data/syllabus_data.dart';
import '../services/app_state.dart';
import '../widgets/app_scaffold.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final subjects = SyllabusData.forGrade(s.grade);

    // घटकनिहाय सर्वोत्तम गुणांवरून कमकुवत घटक (६०% पेक्षा कमी) शोधा
    final weak = <String>[];
    for (final sub in subjects) {
      for (final c in sub.components) {
        for (var i = 0; i < c.subs.length; i++) {
          final b = s.topicBest[sub.topicId(c, i)];
          if (b != null && b < 60) weak.add('${sub.nameMr} ${c.no}.${i + 1} - ${c.subs[i]} ($b%)');
        }
      }
    }

    return AppScaffold(
      title: 'माझी प्रगती',
      body: ListView(padding: const EdgeInsets.all(12), children: [
        Card(
          child: ListTile(
            title: Text('एकूण अचूकता: ${s.accuracy}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${s.totalCorrect} बरोबर / ${s.totalQuestions} प्रश्न  •  ${s.totalSeconds ~/ 60} मिनिटे अभ्यास'),
          ),
        ),
        for (final sub in subjects)
          Builder(builder: (_) {
            final ids = <String>[];
            for (final c in sub.components) {
              for (var i = 0; i < c.subs.length; i++) {
                ids.add(sub.topicId(c, i));
              }
            }
            final done = ids.where(s.topicBest.containsKey).length;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${sub.emoji} ${sub.nameMr}  ($done/${ids.length} घटक)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: ids.isEmpty ? 0 : done / ids.length, minHeight: 10, color: sub.color),
                ]),
              ),
            );
          }),
        const SizedBox(height: 6),
        const Text('🎯 कमकुवत घटक (सराव वाढवा)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.red)),
        if (weak.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('सध्या कोणताही कमकुवत घटक नाही. 👍')),
        for (final w in weak) ListTile(dense: true, leading: const Icon(Icons.warning_amber, color: AppColors.orange), title: Text(w)),
      ]),
    );
  }
}
