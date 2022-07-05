import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // primaryColor: Colors.purple.shade300,
        accentColor: Colors.teal,
      ),
      title: 'Flutter Share',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
