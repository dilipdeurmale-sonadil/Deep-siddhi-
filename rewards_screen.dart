import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../services/app_state.dart';
import '../widgets/app_scaffold.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  static const store = <(String, int)>[
    ('🐯 वाघ अवतार', 100),
    ('🚀 रॉकेट अवतार', 150),
    ('🌈 इंद्रधनुष्य थीम', 200),
    ('👑 चॅम्पियन फ्रेम', 300),
  ];

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return AppScaffold(
      title: 'बक्षीसे',
      body: ListView(padding: const EdgeInsets.all(12), children: [
        Center(child: Text('🪙 ${s.coins} नाणी   ⭐ ${s.stars} तारे', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Text('🎡', style: TextStyle(fontSize: 30)),
            title: const Text('रोजचे लकी स्पिन', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(s.canSpinToday ? 'आज एकदा फिरवा!' : 'उद्या पुन्हा या!'),
            trailing: ElevatedButton(
              onPressed: s.canSpinToday
                  ? () {
                      final r = [5, 10, 15, 20, 50][Random().nextInt(5)];
                      s.spinWheel(r);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🎉 तुम्हाला $r नाणी मिळाली!')));
                    }
                  : null,
              child: const Text('फिरवा'),
            ),
          ),
        ),
        const Text('🏅 माझे बॅज', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        if (s.badges.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('सराव करून पहिला बॅज मिळवा!')),
        for (final b in s.badges) ListTile(dense: true, title: Text(b)),
        const Divider(),
        const Text('🛍️ रिवॉर्ड स्टोअर', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        for (final item in store)
          ListTile(
            title: Text(item.$1),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
              onPressed: () {
                final ok = s.spend(item.$2);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? '✅ ${item.$1} मिळाले!' : 'नाणी कमी आहेत.')),
                );
              },
              child: Text('🪙 ${item.$2}'),
            ),
          ),
      ]),
    );
  }
}
