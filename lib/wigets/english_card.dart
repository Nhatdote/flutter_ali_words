import 'package:flutter/material.dart';
import 'package:flutter_app/models/english_word.dart';

import '../ultils/style.dart';

class EnglishCard extends StatelessWidget {
  final EnglishWord word;

  const EnglishCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: const BoxDecoration(
                        color: AppStyle.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 3),
                              blurRadius: 4)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.heart_broken,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: word.letter,
                              style: AppStyle.h1.copyWith(height: 1, shadows: [
                                const BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(3, 6),
                                    blurRadius: 6)
                              ]),
                              children: [
                                TextSpan(
                                    text: word.after,
                                    style: AppStyle.h3
                                        .copyWith(fontSize: 54, shadows: []))
                              ]),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 16),
                            child: SingleChildScrollView(
                                child: Text(
                              '"${word.quote}"',
                              style: const TextStyle(
                                  fontSize: 20, letterSpacing: 0.5),
                            )),
                          ),
                        )
                      ],
                    ));
  }
}