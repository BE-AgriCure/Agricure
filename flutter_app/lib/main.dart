import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agricare/screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp();
  
  runApp(const AgriCureApp());
}

class AgriCureApp extends StatelessWidget {
  const AgriCureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriCure',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
