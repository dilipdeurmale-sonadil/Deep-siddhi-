import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/tts_service.dart';
import '../widgets/app_scaffold.dart';
import 'result_screen.dart';

/// एका पानावर, scroll न करता: प्रश्न + ४ पर्याय + हिंट + मागे/पुढे/बाहेर.
/// प्रत्येक प्रश्नाला ३० सेकंद; बरोबर = हिरवा, चूक = लाल.
class QuizScreen extends StatefulWidget {
  final String title;
  final String? topicId;
  final List<Question> questions;
  final int seconds;
  const QuizScreen({
    super.key,
    required this.title,
    required this.questions,
    this.topicId,
    this.seconds = AppConst.secondsPerQuestion,
  });
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<int?> _picked = List.filled(widget.questions.length, null);
  int _i = 0;
  late int _left = widget.seconds;
  Timer? _timer;
  final _started = DateTime.now();

  Question get _q => widget.questions[_i];
  bool get _locked => _picked[_i] != null;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    TtsService.stop();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _left = widget.seconds;
    if (_locked) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _left--);
      if (_left <= 0) {
        t.cancel();
        setState(() => _picked[_i] = -1); // वेळ संपली
      }
    });
  }

  void _pick(int k) {
    if (_locked) return;
    _timer?.cancel();
    setState(() => _picked[_i] = k);
  }

  void _go(int delta) {
    final n = _i + delta;
    if (n < 0) return;
    if (n >= widget.questions.length) {
      _finish();
      return;
    }
    setState(() => _i = n);
    _startTimer();
  }

  void _finish() {
    _timer?.cancel();
    var correct = 0;
    for (var k = 0; k < widget.questions.length; k++) {
      if (_picked[k] == widget.questions[k].answer) correct++;
    }
    final secs = DateTime.now().difference(_started).inSeconds;
    final coins = context.read<AppState>().addResult(
          topicId: widget.topicId,
          correct: correct,
          total: widget.questions.length,
          seconds: secs,
        );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => ResultScreen(correct: correct, total: widget.questions.length, coins: coins),
    ));
  }

  Color _optColor(int k) {
    if (!_locked) return Colors.white;
    if (k == _q.answer) return AppColors.green;
    if (k == _picked[_i]) return AppColors.red;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.questions.length;
    final urgent = _left <= 5 && !_locked;
    return AppScaffold(
      title: widget.title,
      showHome: false,
      actions: [
        IconButton(tooltip: 'बाहेर पडा', icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
      ],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(children: [
            Text('प्रश्न ${_i + 1}/$total', style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: urgent ? AppColors.red : AppColors.orange,
              child: Text('${_locked ? 0 : _left}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ]),
          LinearProgressIndicator(value: (_i + 1) / total, minHeight: 6, color: AppColors.green),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.yellow.withOpacity(0.25), borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 90),
                      child: Text(_q.q, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => TtsService.speak(_q.q, english: _q.topicId.startsWith('en')),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            flex: 5,
            child: Column(children: [
              for (var k = 0; k < _q.options.length; k++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: InkWell(
                      onTap: () => _pick(k),
                      borderRadius: BorderRadius.circular(14),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: _optColor(k),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.blue, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            '${['अ', 'ब', 'क', 'ड'][k]})  ${_q.options[k]}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: _optColor(k) == Colors.white ? Colors.black87 : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ]),
          ),
          SizedBox(
            height: 40,
            child: Center(
              child: _locked
                  ? Text(
                      _picked[_i] == -1 ? '⏰ वेळ संपली! 💡 ${_q.hint}' : '💡 ${_q.hint}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.purple, fontWeight: FontWeight.bold),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: _i == 0 ? null : () => _go(-1), icon: const Icon(Icons.arrow_back), label: const Text('मागे'))),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _go(1),
                icon: Icon(_i == total - 1 ? Icons.flag : Icons.arrow_forward),
                label: Text(_i == total - 1 ? 'पूर्ण' : 'पुढे'),
              ),
            ),
          ]),
          const SizedBox(height: 6),
        ]),
      ),
    );
  }
}
