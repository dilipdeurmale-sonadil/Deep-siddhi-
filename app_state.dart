import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// स्थानिक (Hive) प्रगती: नाणी, तारे, स्ट्रीक, घटकनिहाय सर्वोत्तम गुण.
/// Firestore sync: firebase/README मधील 'syncQueue' धोरण पाहा.
class AppState extends ChangeNotifier {
  final Box _box = Hive.box('progress');

  int grade = 4;
  int coins = 0;
  int stars = 0;
  int xp = 0;
  int streak = 0;
  String studentName = 'विद्यार्थी मित्र';
  String lastActiveDay = '';
  String lastSpinDay = '';
  Map<String, int> topicBest = {}; // topicId -> best %
  int totalQuestions = 0;
  int totalCorrect = 0;
  int totalSeconds = 0;

  void load() {
    grade = _box.get('grade', defaultValue: 4) as int;
    coins = _box.get('coins', defaultValue: 0) as int;
    stars = _box.get('stars', defaultValue: 0) as int;
    xp = _box.get('xp', defaultValue: 0) as int;
    streak = _box.get('streak', defaultValue: 0) as int;
    studentName = _box.get('name', defaultValue: 'विद्यार्थी मित्र') as String;
    lastActiveDay = _box.get('lastActiveDay', defaultValue: '') as String;
    lastSpinDay = _box.get('lastSpinDay', defaultValue: '') as String;
    totalQuestions = _box.get('tq', defaultValue: 0) as int;
    totalCorrect = _box.get('tc', defaultValue: 0) as int;
    totalSeconds = _box.get('ts', defaultValue: 0) as int;
    topicBest = Map<String, int>.from((_box.get('topicBest', defaultValue: {}) as Map).cast<String, int>());
  }

  int get level => xp ~/ 100 + 1;

  String _today() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }

  void setGrade(int g) {
    grade = g;
    _box.put('grade', g);
    notifyListeners();
  }

  void setName(String n) {
    studentName = n;
    _box.put('name', n);
    notifyListeners();
  }

  /// क्विझ संपल्यावर निकाल नोंदवा. परत: मिळालेली नाणी.
  int addResult({String? topicId, required int correct, required int total, int seconds = 0}) {
    final pct = total == 0 ? 0 : (correct * 100 ~/ total);
    final earnedCoins = correct * 2 + (pct >= 80 ? 10 : 0);
    final earnedStars = pct >= 90 ? 3 : pct >= 60 ? 2 : pct >= 30 ? 1 : 0;
    coins += earnedCoins;
    stars += earnedStars;
    xp += correct * 5 + 5;
    totalQuestions += total;
    totalCorrect += correct;
    totalSeconds += seconds;
    if (topicId != null && pct > (topicBest[topicId] ?? -1)) topicBest[topicId] = pct;
    _updateStreak();
    _persist();
    notifyListeners();
    return earnedCoins;
  }

  void _updateStreak() {
    final today = _today();
    if (lastActiveDay == today) return;
    final y = DateTime.now().subtract(const Duration(days: 1));
    final yesterday = '${y.year}-${y.month}-${y.day}';
    streak = lastActiveDay == yesterday ? streak + 1 : 1;
    lastActiveDay = today;
    if (streak % 7 == 0) coins += 50; // साप्ताहिक बोनस
  }

  bool get canSpinToday => lastSpinDay != _today();

  int spinWheel(int reward) {
    if (!canSpinToday) return 0;
    lastSpinDay = _today();
    coins += reward;
    _persist();
    notifyListeners();
    return reward;
  }

  bool spend(int cost) {
    if (coins < cost) return false;
    coins -= cost;
    _persist();
    notifyListeners();
    return true;
  }

  int get accuracy => totalQuestions == 0 ? 0 : totalCorrect * 100 ~/ totalQuestions;

  List<String> get badges {
    final b = <String>[];
    if (totalQuestions >= 10) b.add('🌱 पहिले पाऊल (१० प्रश्न)');
    if (totalCorrect >= 50) b.add('⭐ अभ्यासू (५० बरोबर)');
    if (streak >= 3) b.add('🔥 सलग ३ दिवस');
    if (streak >= 7) b.add('🏅 सात दिवसांचा योद्धा');
    if (accuracy >= 80 && totalQuestions >= 20) b.add('🎯 अचूक नेमबाज');
    if (level >= 5) b.add('🚀 लेव्हल ५');
    return b;
  }

  void _persist() {
    _box.putAll({
      'coins': coins, 'stars': stars, 'xp': xp, 'streak': streak,
      'lastActiveDay': lastActiveDay, 'lastSpinDay': lastSpinDay,
      'tq': totalQuestions, 'tc': totalCorrect, 'ts': totalSeconds,
      'topicBest': topicBest,
    });
  }
}
