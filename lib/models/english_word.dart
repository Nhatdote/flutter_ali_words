import 'dart:math';

import 'package:english_words/english_words.dart';

class EnglishWord {
  String? id;
  String? letter;
  String? after;
  String? noun;
  String? quote;
  bool isFavorite;

  EnglishWord({
    this.id, 
    this.letter, 
    this.after, 
    this.noun, 
    this.quote, 
    this.isFavorite = false
  });

  static List<EnglishWord> getList([int len = 5]) {
    final random = Random();

    int start = random.nextInt(1000) + 1;
    int end = start + len;

    Iterable<String> items = nouns.getRange(start, end);

    return items
        .map((h) => EnglishWord(
            id: h,
            letter: h.substring(0, 1).toUpperCase(),
            after: h.substring(1),
            noun: h,
            quote: getQuote(40)
          )
        )
        .toList();
  }

  static String getQuote([int len = 15]) {
    final random = Random();
    int start = random.nextInt(500) + 1;
    int length = random.nextInt(len) + 8;
    int end = start + length;

    String string = nouns.getRange(start, end).join(' ');

    return string.substring(0, 1).toUpperCase() + string.substring(1);
  }
}