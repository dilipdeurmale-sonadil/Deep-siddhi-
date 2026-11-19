import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../data/syllabus_data.dart';
import '../services/app_state.dart';
import '../services/question_repository.dart';
import '../widgets/app_scaffold.dart';
import 'about_screen.dart';
import 'dashboards_screen.dart';
import 'grade_select_screen.dart';
import 'mock_test_screen.dart';
import 'progress_screen.dart';
import 'quiz_screen.dart';
import 'rewards_screen.dart';
import 'subject_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final subjects = SyllabusData.forGrade(s.grade);

    void go(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

    Widget stat(String e, String v) => Chip(label: Text('$e $v', style: const TextStyle(fontWeight: FontWeight.bold)));

    Widget tile(String e, String label, Color c, VoidCallback onTap) => GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(16)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(e, style: const TextStyle(fontSize: 26)),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ]),
          ),
        );

    return AppScaffold(
      title: 'इयत्ता ${s.grade} वी',
      showHome: false,
      actions: [
        IconButton(
          tooltip: 'इयत्ता बदला',
          icon: const Icon(Icons.swap_horiz),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const GradeSelectScreen())),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Text('नमस्कार, ${s.studentName}! 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(spacing: 6, children: [
            stat('🪙', '${s.coins}'),
            stat('⭐', '${s.stars}'),
            stat('🔥', '${s.streak} दिवस'),
            stat('🏆', 'लेव्हल ${s.level}'),
          ]),
          Expanded(
            flex: 5,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                for (final sub in subjects)
                  GestureDetector(
                    onTap: () => go(SubjectScreen(subject: sub)),
                    child: Container(
                      decoration: BoxDecoration(color: sub.color, borderRadius: BorderRadius.circular(20)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(sub.emoji, style: const TextStyle(fontSize: 34)),
                        Text(sub.nameMr, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                tile('⚡', 'दैनिक आव्हान', AppColors.orange, () {
                  final qs = QuestionRepository.allForGrade(s.grade)..shuffle();
                  go(QuizScreen(title: 'दैनिक आव्हान', questions: qs.take(10).toList()));
                }),
                tile('📝', 'मॉक टेस्ट', AppColors.blue, () => go(const MockTestScreen())),
                tile('📊', 'प्रगती', AppColors.green, () => go(const ProgressScreen())),
                tile('🎁', 'बक्षीसे', AppColors.purple, () => go(const RewardsScreen())),
                tile('👪', 'पालक', AppColors.blue, () => go(const DashboardScreen(teacher: false))),
                tile('👩‍🏫', 'शिक्षक', AppColors.orange, () => go(const DashboardScreen(teacher: true))),
                tile('ℹ️', 'माहिती केंद्र', AppColors.green, () => go(const AboutScreen())),
                tile('👨‍💻', 'निर्माता', AppColors.purple, () => go(const AboutScreen())),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
