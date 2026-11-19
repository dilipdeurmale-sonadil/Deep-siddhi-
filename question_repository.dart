import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class QuestionRepository {
  static List<Question> _all = [];

  static Future<void> load() async {
    final raw = await rootBundle.loadString('assets/data/questions.json');
    _all = (json.decode(raw) as List)
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<Question> byTopic(int grade, String topicId, {int? level}) => _all
      .where((q) => q.grade == grade && q.topicId == topicId && (level == null || q.level == level))
      .toList();

  static List<Question> bySubject(int grade, String subjectId) =>
      _all.where((q) => q.grade == grade && q.topicId.startsWith('$subjectId-')).toList();

  static List<Question> allForGrade(int grade) => _all.where((q) => q.grade == grade).toList();
}
