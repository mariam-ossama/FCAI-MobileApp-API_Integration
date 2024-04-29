import 'package:assignment/screens/edit_profile_screen.dart';
import 'package:assignment/screens/login_screen.dart';
import 'package:assignment/screens/profile_screen.dart';
import 'package:assignment/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
      routes: {
        'LoginPage': (context) => LoginPage(),
        'ProfilePage': (context) => ProfilePage(),
        'EditProfilePage':(context) => EditProfilePage(),
      }
    );
  }
}


