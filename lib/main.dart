import 'package:flutter/material.dart';
import 'package:homestay/screens/login_screen.dart';
import 'package:homestay/screens/signup_screen.dart';
import 'package:homestay/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Homestay',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColorDark,
      ),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text("Homestay"),
      //   ),
      //   body: const Text("Something is here"),
      // ),
      home: SignupScreen(),
    );
  }
}
