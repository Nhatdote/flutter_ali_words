import 'package:flutter/material.dart';
import 'package:flutter_ali_words/models/english_word.dart';
import 'package:flutter_ali_words/utils/db.dart';
import 'package:flutter_ali_words/utils/toast.dart';


class Utils {

  static toggleFavorite(EnglishWord word) async {
    if (word.noun == null) {
      return;
    }

    Set<String> favorites = (DB.prefs.getStringList(DB.favorites) ?? []).toSet();
    late dynamic message;
    late Color color;
    
    if (word.isFavorite) {
      favorites.add(word.noun!);
      color = Colors.green;
      message = RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Added '),
                TextSpan(
                  text: '"${word.noun!.toUpperCase()}"',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' to favotite words!'),
              ],
            ),
          );
    } else {
      favorites.remove(word.noun);
      color = Colors.redAccent;
      message = RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Removed '),
                TextSpan(
                  text: '"${word.noun!.toUpperCase()}"',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' from favotite words!'),
              ],
            ),
          );
    }

    await DB.prefs.setStringList(DB.favorites, favorites.toList());

    Toast.show(message, color: color);
  }
  
}