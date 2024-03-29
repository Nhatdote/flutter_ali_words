import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ali_words/screens/landing.dart';
import 'package:flutter_ali_words/utils/db.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DB.init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

    return const MaterialApp(
      title: 'English words',
      home: LandingPage(),
    );
  }
}