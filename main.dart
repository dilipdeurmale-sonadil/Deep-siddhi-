import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'services/app_state.dart';
import 'services/question_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('progress');
  await QuestionRepository.load();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: const ScholarApp(),
    ),
  );
}

class ScholarApp extends StatelessWidget {
  const ScholarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConst.appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
    );
  }
}
