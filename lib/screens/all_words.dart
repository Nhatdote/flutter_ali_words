import 'package:flutter/material.dart';
import 'package:flutter_ali_words/models/english_word.dart';
import 'package:flutter_ali_words/utils/style.dart';
import 'package:flutter_ali_words/utils/utils.dart';
import 'package:flutter_ali_words/wigets/skeleton.dart';

class AllWords extends StatefulWidget {
  const AllWords({super.key});

  @override
  State<AllWords> createState() => _AllWordsState();
}

class _AllWordsState extends State<AllWords> {
  final ScrollController _scrollController = ScrollController();
  List<Future<EnglishWord>> list = [];
  int start = 0;
  final int offset = 20;

  load() async {
    List<Future<EnglishWord>> items = EnglishWord.paginate(start);

    setState(() {
      start += offset;
      list += items;
    });

    await Future.wait(items);
  }

  toggleFavorite(int index) async {
    if (index >= 0 && index <= list.length) { 
      Future<EnglishWord> futureWord = list[index];
      EnglishWord word = await futureWord;

      setState(() {
        word.isFavorite = !word.isFavorite;
      });

      Utils.toggleFavorite(word);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      load();
      _scrollController.animateTo(_scrollController.offset + 50, duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    load();
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
                itemCount: list.length + 1,
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return const Skeleton(length: 5);
                  }

                  return FutureBuilder(
                    future: list[index],
                    builder:(context, snapshot) {
                      if (snapshot.hasData) {
                        final EnglishWord word = snapshot.data!;
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
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const Skeleton(length: 1);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}