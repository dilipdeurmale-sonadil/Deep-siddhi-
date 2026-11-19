import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/app_scaffold.dart';
import 'grade_select_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue, AppColors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            const Spacer(),
            ScaleTransition(
              scale: Tween(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(AppConst.logoAsset, width: 150, height: 150),
              ),
            ),
            const SizedBox(height: 12),
            const Text(AppConst.appName,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
            const Text(AppConst.appNameEn,
                style: TextStyle(color: Colors.white70, fontSize: 18, letterSpacing: 2)),
            const SizedBox(height: 8),
            const Text(AppConst.tagline,
                style: TextStyle(color: AppColors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const GradeSelectScreen()),
              ),
              child: const Text('चला, सुरुवात करूया!'),
            ),
            const SizedBox(height: 24),
            const Text('${AppConst.creditLine1} ${AppConst.creditLine2}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Text(AppConst.copyright, style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}
