import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/app_scaffold.dart';
import 'topic_screen.dart';

class SubjectScreen extends StatelessWidget {
  final Subject subject;
  const SubjectScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '${subject.emoji} ${subject.nameMr}',
      body: subject.components.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('या इयत्तेचा अभ्यासक्रम लवकरच जोडला जाईल. 🚧',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                for (final c in subject.components)
                  Card(
                    child: ExpansionTile(
                      leading: CircleAvatar(backgroundColor: subject.color, child: Text('${c.no}', style: const TextStyle(color: Colors.white))),
                      title: Text(c.nameMr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('भारांश: ${c.weight}%'),
                      children: [
                        for (var i = 0; i < c.subs.length; i++)
                          ListTile(
                            dense: true,
                            title: Text('${c.no}.${i + 1}  ${c.subs[i]}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => TopicScreen(
                                subject: subject,
                                topicId: subject.topicId(c, i),
                                title: '${c.no}.${i + 1}  ${c.subs[i]}',
                              ),
                            )),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
