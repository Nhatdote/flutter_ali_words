import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter_ali_words/utils/db.dart';

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

  static EnglishWord _make(String word, [Set<String>? favorites]) {
    

    return EnglishWord(
      id: word,
      letter: word.substring(0, 1).toUpperCase(),
      after: word.substring(1),
      noun: word,
      quote: getQuote(40),
      isFavorite: favorites == null ? false : favorites.contains(word)
    );
  }

  static List<EnglishWord> paginate(int start) {
    int perPage = 20;
    Iterable<String> items = nouns.getRange(start, start + perPage);
    Set<String> favorites = (DB.prefs.getStringList(DB.favorites) ?? []).toSet();

    return items
        .map((h) => _make(h, favorites))
        .toList();
  }

  static List<EnglishWord> getFavorite() {
    List<String> items = DB.prefs.getStringList(DB.favorites) ?? [];

    return items.map((e) => _make(e)).toList();
  }

  static List<EnglishWord> getList([int len = 5]) {
    final random = Random();
    Set<String> favorites = (DB.prefs.getStringList(DB.favorites) ?? []).toSet();

    int start = random.nextInt(1000) + 1;
    int end = start + len;

    Iterable<String> items = nouns.getRange(start, end);

    return items
        .map((h) => _make(h, favorites))
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