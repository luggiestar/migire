import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_ame/screens/login.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = const FirebaseOptions(
    appId: '1:448723485142:android:9c96b8e2176e18b7d92477',
    apiKey: 'AIzaSyBZyNuSfwlC1pZUcOSDv-wz1J2hrznssl8',
    projectId: 'checkup-a5d21',
    messagingSenderId: '448723485142',
    // storageBucket: "gs://plwha-68e4e.appspot.com",

  );
  await Firebase.initializeApp(
      options: firebaseOptions
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      home: LoginPage(),
    );
  }
}