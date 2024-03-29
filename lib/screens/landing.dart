import "package:flutter/material.dart";
import "package:flutter_ali_words/screens/home.dart";
import 'package:flutter_ali_words/utils/style.dart';
import "package:flutter_ali_words/utils/toast.dart";

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.initialize(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: AppStyle.primaryColor,
        child: Column(children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text('Welcome to', style: AppStyle.h3),
            ),
          ),
          Expanded(
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('English',
                    style: AppStyle.h2.copyWith(
                        color: AppStyle.blackGrey,
                        fontWeight: FontWeight.bold)),
                Text('Quotes"',
                    style: AppStyle.h4
                        .copyWith(height: 0.5, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right)
              ],
            )),
          ),
          Expanded(
            child: MaterialButton(
              shape: const CircleBorder(),
              color: AppStyle.lightBlue,
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomePage()))
              },
              child: const Icon(
                Icons.navigate_next_rounded,
                size: 55,
                color: Colors.black54,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
