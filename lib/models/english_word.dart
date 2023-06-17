import 'dart:convert';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter_ali_words/utils/api.dart';
import 'package:flutter_ali_words/utils/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class EnglishWord {
  String id;
  String noun;
  String? phonetic;
  String letter;
  String after;
  String? quote;
  bool isFavorite;

  EnglishWord({
    required this.id, 
    required this.noun,
    this.phonetic,
    required this.letter, 
    required this.after, 
    this.quote, 
    this.isFavorite = false
  });

  static Future<EnglishWord> _make(String word, [Set<String>? favorites]) async {
    SharedPreferences prefs = DB.prefs;
    String? json = prefs.getString(word);
    DictionaryApi data = DictionaryApi(word: word);

    if (json != null) {
      data = DictionaryApi.fromJson(json);
    } else {
      final res = await http.get(
        Uri.https(API.dictionaryBaseUrl, "${API.dictionaryPath}/$word")
      );

      if (res.statusCode == 200) {
        data = DictionaryApi.fromJson(res.body);
        prefs.setString(word, jsonEncode([data.toJson()]));
      }
    }

    return EnglishWord(
      id: word,
      noun: word,
      letter: word.substring(0, 1).toUpperCase(),
      after: word.substring(1),
      isFavorite: favorites == null ? false : favorites.contains(word),
      phonetic: data.phonetic,
      quote: DictionaryApi.getRandQuote(data)
    );
  }

  static List<Future<EnglishWord>> paginate(int start) {
    int perPage = 20;
    Iterable<String> items = nouns.getRange(start, start + perPage);
    Set<String> favorites = (DB.prefs.getStringList(DB.favorites) ?? []).toSet();

    return items
        .map((h) => _make(h, favorites))
        .toList();
  }

  static List<Future<EnglishWord>> getFavorite() {
    List<String> items = DB.prefs.getStringList(DB.favorites) ?? [];

    return items.map((e) => _make(e)).toList();
  }

  static List<Future<EnglishWord>> getList([int len = 5]) {
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