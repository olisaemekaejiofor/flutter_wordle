import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordle Clone',
      home: HomePage(),
    );
  }
}

const Color correctColor = Color(0xff538D4E);
const Color inWord = Color(0xffB49F3A);
const Color notInWord = Color(0xff3A3A3C);
