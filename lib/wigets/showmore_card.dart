import 'package:flutter/material.dart';
import 'package:flutter_app/screens/all_words.dart';
import 'package:flutter_app/ultils/style.dart';

class ShowmoreCard extends StatelessWidget {
  const ShowmoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Material(
        color: AppStyle.primaryColor,
        elevation: 6,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AllWords()
            ));
          },
          child: const Center(
            child: Text('All words', style: AppStyle.h3,),
          ),
        ),
      ),
    );
  }
}
