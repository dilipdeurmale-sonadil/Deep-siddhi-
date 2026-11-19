import 'package:flutter/material.dart';

class Component {
  final int no;
  final String nameMr;
  final int weight;
  final List<String> subs;
  const Component(this.no, this.nameMr, this.weight, this.subs);
}

class Subject {
  final String id; // mr, ma, en, iq
  final String nameMr;
  final String emoji;
  final Color color;
  final List<Component> components;
  const Subject(this.id, this.nameMr, this.emoji, this.color, this.components);

  String topicId(Component c, int subIndex) => '$id-${c.no}-${subIndex + 1}';
}

class Question {
  final String id;
  final int grade;
  final String topicId;
  final int level; // 1,2,3, 4 = Scholarship Champion
  final String q;
  final List<String> options;
  final int answer;
  final String hint;
  const Question({
    required this.id,
    required this.grade,
    required this.topicId,
    required this.level,
    required this.q,
    required this.options,
    required this.answer,
    required this.hint,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        id: j['id'] as String,
        grade: j['grade'] as int,
        topicId: j['topicId'] as String,
        level: j['level'] as int,
        q: j['q'] as String,
        options: List<String>.from(j['options'] as List),
        answer: j['answer'] as int,
        hint: (j['hint'] ?? '') as String,
      );
}
