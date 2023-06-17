import 'dart:convert';

import 'package:flutter_ali_words/utils/utils.dart';

class API {
  static const collegiateKey = 'c61f920c-239b-4543-9517-1564c7143f5c';
  static const collegiateBaseUrl = 'www.dictionaryapi.com';
  static const collegiatePath = 'api/v3/references/collegiate/json';

  static const thesaurusKey = '352b885a-f1db-4734-be29-c77014291dc3';
  static const thesaurusBaseUrl = 'www.dictionaryapi.com';
  static const thesaurusPath = 'api/v3/references/thesaurus/json';

  static const dictionaryBaseUrl = 'api.dictionaryapi.dev';
  static const dictionaryPath = 'api/v2/entries/en';

  static const quotableBaseUrl = 'api.quotable.io';
  static const quotablePath = 'random';
}

class DictionaryApi {
  String word;
  String? phonetic;
  List<dynamic>? meanings;

  DictionaryApi({
    required this.word, 
    this.phonetic, 
    this.meanings
  });

  factory DictionaryApi.fromJson(String json) {
    List<dynamic> list = jsonDecode(json);

    if (list.isNotEmpty) {
      Map<String, dynamic> data = list[0];

      return DictionaryApi(
        word: data['word'],
        phonetic: data['phonetic'],
        meanings: data['meanings']
      );
    }

    throw Exception('Invalid JSON format');
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'phonetic': phonetic,
      'meanings': meanings,
    };
  }

  static String getRandQuote(DictionaryApi data) {
    List<dynamic> meanings = data.meanings ?? [];

    if (meanings.isEmpty) {
      return '';
    } 

    Map<String, dynamic> meaning = Utils.randomArray(meanings);

    List<dynamic> definitions = meaning['definitions'];
    
    return Utils.randomArray(definitions)['definition'];
  }
}
