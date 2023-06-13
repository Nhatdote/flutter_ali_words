import 'dart:convert';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter_ali_words/utils/api.dart';
import 'package:flutter_ali_words/utils/db.dart';
import 'package:flutter_ali_words/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class EnglishWord {
  String? id;
  String? letter;
  String? after;
  String noun;
  String? quote;
  bool isFavorite;

  EnglishWord({
    this.id, 
    this.letter, 
    this.after, 
    required this.noun, 
    this.quote, 
    this.isFavorite = false
  });

  static Future<EnglishWord> _make(String word, [Set<String>? favorites]) async {
    SharedPreferences prefs = DB.prefs;
    String? quote = prefs.getString(word);

    // quote = null;
    if (quote == null) {
      final res = await http.get(
        Uri.https(API.collegiateBaseUrl, "${API.collegiatePath}/$word", {
          'key': API.collegiateKey
        })
      );

      if (res.statusCode == 200) {
        List<dynamic>? data = jsonDecode(res.body);

        if (data.runtimeType == List<dynamic>) {
          try {
            if (data![0]?['shortdef']?[0] != null) {
              quote = Utils.randomArray(data[0]?['shortdef']);
              quote = quote!.substring(0, 1).toUpperCase() + quote.substring(1);
              prefs.setString(word, quote);
            }
          } catch (error) {
            quote = "$error";
          }
        }
      }
    }

    return EnglishWord(
      id: word,
      letter: word.substring(0, 1).toUpperCase(),
      after: word.substring(1),
      noun: word,
      quote: quote ?? getQuote(40),
      isFavorite: favorites == null ? false : favorites.contains(word)
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