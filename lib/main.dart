import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photofolio/color_schemes.g.dart';
import 'package:photofolio/pages/authentication/loginScreen.dart';
import 'package:photofolio/pages/mainscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}


