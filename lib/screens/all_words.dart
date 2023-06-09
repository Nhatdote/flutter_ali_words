import 'package:flutter/material.dart';
import 'package:flutter_app/models/english_word.dart';
import 'package:flutter_app/ultils/db_keys.dart';
import 'package:flutter_app/ultils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../wigets/favorite_btn.dart';

class AllWords extends StatefulWidget {
  const AllWords({super.key});

  @override
  State<AllWords> createState() => _AllWordsState();
}

class _AllWordsState extends State<AllWords> {
  late SharedPreferences prefs;
  final ScrollController _scrollController = ScrollController();
  List<EnglishWord> list = [];
  int start = 0;
  bool showLoading = false;
  final int offset = 20;

  load() {
    List<EnglishWord> items = EnglishWord.paginate(start);
    setState(() {
      start += offset;
      list += items;
      showLoading = false;
    });
  }

  toggleFavorite(int index) {
    if (index >= 0 && index <= list.length) { 
      EnglishWord word = list[index];

      setState(() {
        word.isFavorite = !word.isFavorite;
      });

      Set<String> favorite = (prefs.getStringList(DBKeys.favorites) ?? []).toSet();
      if (word.noun != null) {
        favorite.add(word.noun!);
        prefs.setStringList(DBKeys.favorites, favorite.toList());
      }
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent) {
      setState(() {
        showLoading = true;
      });
    }

    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      await load();
      _scrollController.animateTo(_scrollController.offset + 50, duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    load();

    () async {
      prefs = await SharedPreferences.getInstance();
    }();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.primaryColor,
      appBar: AppBar(
         iconTheme: const IconThemeData(
          color: AppStyle.textColor
        ),
        backgroundColor: AppStyle.primaryColor,
        elevation: 0,
        title: const Text('All words', style: TextStyle(color: AppStyle.textColor)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  EnglishWord word = list[index];
                  String label = '${word.letter}${word.after}';
            
                  return Material(
                    color: index % 2 == 0 ? Colors.black12 : AppStyle.primaryColor, 
                    child: InkWell(
                      onDoubleTap: () => toggleFavorite(index),
                      splashColor: Colors.transparent,
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(bottom: 6, left: 16, right: 16),
                        // leading: FavoriteBtn(isFavorite: word.isFavorite, onToggleFavorite: () => toggleFavorite(index)),
                        
                        leading: InkWell(
                          onTap: () => toggleFavorite(index),
                          child: Icon(
                            Icons.favorite,
                            color: word.isFavorite ? Colors.red : Colors.white,
                          ),
                        ),
                        title: Text(label, style: AppStyle.h4.copyWith(color: AppStyle.textColor)),
                        subtitle: Text(word.quote ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: !showLoading 
                ? const Text(' ') 
                : const Text('Loading...'),
            )
          ],
        ),
      )
    );
  }
}