import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/app_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'माहिती / निर्माता',
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Center(child: Image(image: AssetImage(AppConst.logoAsset), width: 90, height: 90)),
        Center(child: Text('${AppConst.appName} (${AppConst.appNameEn})', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
        Center(child: Text(AppConst.tagline, style: TextStyle(color: AppColors.purple, fontWeight: FontWeight.bold))),
        Divider(height: 30),
        Text('शिष्यवृत्ती माहिती', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        Text('हे ॲप महाराष्ट्र राज्य परीक्षा परिषद, पुणे यांच्या इ. ४ थी प्राथमिक शिष्यवृत्ती अभ्यासक्रमावर (शासन पत्र दि. ०४/११/२०२५) आधारित आहे. परीक्षेच्या तारखा व नोंदणीसाठी परिषदेचे अधिकृत संकेतस्थळ पाहा.'),
        Divider(height: 30),
        Text('निर्माता परिचय', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        Text('${AppConst.creditLine1}\n${AppConst.creditLine2}', style: TextStyle(fontSize: 16, color: AppColors.purple, fontWeight: FontWeight.bold)),
        Text(AppConst.developerDetail),
        SizedBox(height: 10),
        Text(AppConst.copyright),
      ]),
    );
  }
}
