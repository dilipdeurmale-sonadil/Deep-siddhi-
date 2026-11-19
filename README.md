# दीपसिद्धी (DeepSiddhi) — शिष्यवृत्ती स्मार्ट सराव
इयत्ता ४ थी व ७ वी शिष्यवृत्ती परीक्षा सराव ॲप (मराठी).
निर्मिती व संकल्पना: श्री. दिलीप के. देऊरमले

## चालवण्यासाठी
```
flutter create . --org com.deepsiddhi --project-name deepsiddhi
flutter pub get
dart run flutter_launcher_icons      # ॲप आयकॉन (assets/icon) Android/iOS मध्ये बसवतो
flutter run
```
Android ॲपचे नाव (होम स्क्रीनवर): `android/app/src/main/AndroidManifest.xml` मध्ये `android:label="दीपसिद्धी"` करा.

## सद्य स्थिती
- इ. ४ थी अभ्यासक्रम PDF नुसार; इ. ७ वी घटक `lib/data/syllabus_data.dart` मध्ये भरायचे आहेत
- प्रश्न JSON: `assets/data/questions.json` (topicId = `विषय-घटक-उपघटक`, उदा. `mr-2-1`)
- Firestore: `firebase/` ; Firebase जोडणी अजून बाकी
