import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracking/pages/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
    );
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: "AIzaSyCSaqs7POioTAwGTSUrKwNhVtqwcMsLSak",
      appId: "1:231970717598:android:486147ccd8de080cca208f",
      messagingSenderId: "231970717598",
      projectId: "tracking-d52cd",
      storageBucket: "tracking-d52cd.firebasestorage.app",
    );
  }
}
