import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/app_scaffold.dart';

class ResultScreen extends StatefulWidget {
  final int correct, total, coins;
  const ResultScreen({super.key, required this.correct, required this.total, required this.coins});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 3));
  int get pct => widget.total == 0 ? 0 : widget.correct * 100 ~/ widget.total;

  @override
  void initState() {
    super.initState();
    if (pct >= 60) _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  String get message => pct >= 90
      ? 'शाब्बास! तू खरा स्कॉलर आहेस! 🏆'
      : pct >= 60
          ? 'छान! आणखी थोडा सराव, यश नक्की! 🌟'
          : 'काळजी करू नको, चुकांमधूनच शिकतो! पुन्हा प्रयत्न कर 💪';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'निकाल',
      body: Stack(alignment: Alignment.topCenter, children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$pct%', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: AppColors.blue)),
              Text('${widget.correct} / ${widget.total} बरोबर', style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('🪙 +${widget.coins} नाणी मिळाली', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('पुढे चला')),
            ]),
          ),
        ),
        ConfettiWidget(
          confettiController: _confetti,
          blastDirection: pi / 2,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          colors: const [AppColors.blue, AppColors.green, AppColors.orange, AppColors.purple, AppColors.yellow],
        ),
      ]),
    );
  }
}
