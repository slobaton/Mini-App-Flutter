// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_screen.dart'; // 👈 nuevo archivo
// import 'screens/login_screen.dart'; // ya no se usa

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini-App Flutter',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: AuthScreen(), // 👈 cambiamos aquí
      debugShowCheckedModeBanner: false,
    );
  }
}
