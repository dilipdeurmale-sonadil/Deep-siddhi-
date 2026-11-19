import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/app_scaffold.dart';

/// पालक / शिक्षक डॅशबोर्ड. सध्या फक्त या उपकरणावरील डेटा दाखवतो;
/// वर्ग/शाळा स्तरावरील एकत्रित अहवाल Firestore sync चालू केल्यावर (firebase/ फोल्डर पाहा).
class DashboardScreen extends StatelessWidget {
  final bool teacher;
  const DashboardScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    Widget row(String k, String v) => ListTile(dense: true, title: Text(k), trailing: Text(v, style: const TextStyle(fontWeight: FontWeight.bold)));
    return AppScaffold(
      title: teacher ? '👩‍🏫 शिक्षक डॅशबोर्ड' : '👪 पालक डॅशबोर्ड',
      body: ListView(padding: const EdgeInsets.all(12), children: [
        Card(child: Column(children: [
          row('विद्यार्थी', s.studentName),
          row('इयत्ता', '${s.grade} वी'),
          row('एकूण सोडवलेले प्रश्न', '${s.totalQuestions}'),
          row('अचूकता', '${s.accuracy}%'),
          row('अभ्यास वेळ', '${s.totalSeconds ~/ 60} मिनिटे'),
          row('सलग दिवस (Streak)', '${s.streak}'),
          row('पूर्ण केलेले घटक', '${s.topicBest.length}'),
        ])),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            teacher
                ? 'वर्ग निरीक्षण, विद्यार्थी तुलना व PDF अहवाल: Firebase जोडल्यानंतर सक्रिय होतील.'
                : 'दैनिक अहवाल व नोटिफिकेशन: Firebase जोडल्यानंतर सक्रिय होतील.',
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        if (!teacher)
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('विद्यार्थ्याचे नाव बदला'),
            onTap: () async {
              final c = TextEditingController(text: s.studentName);
              final name = await showDialog<String>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('नाव'),
                  content: TextField(controller: c),
                  actions: [TextButton(onPressed: () => Navigator.pop(context, c.text), child: const Text('जतन करा'))],
                ),
              );
              if (name != null && name.trim().isNotEmpty) s.setName(name.trim());
            },
          ),
      ]),
    );
  }
}
