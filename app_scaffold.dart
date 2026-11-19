import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../screens/home_screen.dart';

/// प्रत्येक पानावर खाली निर्मिती/हक्क ओळ दाखवणारा सामायिक Scaffold.
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showHome;
  const AppScaffold({super.key, required this.title, required this.body, this.actions, this.showHome = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          ...?actions,
          if (showHome)
            IconButton(
              tooltip: 'मुख्य मेनू',
              icon: const Icon(Icons.home_rounded),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (r) => false,
              ),
            ),
        ],
      ),
      body: body,
      bottomNavigationBar: const BrandingFooter(),
    );
  }
}

class BrandingFooter extends StatelessWidget {
  const BrandingFooter({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4),
        color: Colors.white,
        child: const Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${AppConst.creditLine1} ${AppConst.creditLine2}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.purple)),
          Text(AppConst.copyright, style: TextStyle(fontSize: 10, color: Colors.black54)),
        ]),
      ),
    );
  }
}
