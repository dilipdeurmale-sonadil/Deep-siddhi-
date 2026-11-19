import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../services/app_state.dart';
import '../widgets/app_scaffold.dart';
import 'home_screen.dart';

class GradeSelectScreen extends StatelessWidget {
  const GradeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    Widget card(int g, String label, String sub, Color c) => Expanded(
          child: GestureDetector(
            onTap: () {
              state.setGrade(g);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(24)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$g', style: const TextStyle(fontSize: 90, color: Colors.white, fontWeight: FontWeight.w900)),
                Text(label, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(sub, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
              ]),
            ),
          ),
        );
    return AppScaffold(
      title: 'तुमची इयत्ता निवडा',
      showHome: false,
      body: Column(children: [
        const SizedBox(height: 12),
        const Text('कोणत्या वर्गाची तयारी करायची?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Expanded(
          child: Row(children: [
            card(4, 'इयत्ता ४ थी', 'प्राथमिक शिष्यवृत्ती', AppColors.orange),
            card(7, 'इयत्ता ७ वी', 'उच्च प्राथमिक शिष्यवृत्ती', AppColors.green),
          ]),
        ),
      ]),
    );
  }
}
