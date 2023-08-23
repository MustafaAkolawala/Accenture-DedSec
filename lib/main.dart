import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/home_screen.dart';
import 'package:hackathon/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackathon/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Finance app',
        theme: ThemeData(useMaterial3: true),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Splashscreen();
              }
              if (snapshot.hasData) {
                return const Homescreen();
              }
              return const login();
            }));
  }
}
