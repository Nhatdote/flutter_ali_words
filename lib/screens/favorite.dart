import 'package:flutter/material.dart';
import 'package:flutter_ali_words/models/english_word.dart';
import 'package:flutter_ali_words/utils/style.dart';
import 'package:flutter_ali_words/utils/utils.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final ScrollController _scrollController = ScrollController();
  List<Future<EnglishWord>> list = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      list = EnglishWord.getFavorite();
    });
  }

  void unFavorite(int index) async {
    final EnglishWord word = await list[index];

    setState(() {
      list.removeAt(index);
    });

    word.isFavorite = false;
    Utils.updateFavorite(word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.primaryColor,
      appBar: AppBar(
        backgroundColor: AppStyle.primaryColor,
        elevation: 0,
        title: const Text('Favorites', style: TextStyle(color: AppStyle.textColor)),
        iconTheme: const IconThemeData(
          color: AppStyle.textColor
        ),
      ),
      body: SafeArea(
        child: list.isEmpty 
            ? _emptyMessage() 
            : ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<EnglishWord>(
                    future: list[index],
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final EnglishWord word = snapshot.data!;
                        String label = '${word.letter}${word.after}';

                        return Material(
                          color: index % 2 == 0 ? Colors.black12 : AppStyle.primaryColor, 
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) => unFavorite(index),
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(bottom: 6, left: 16, right: 16),
                              leading: InkWell(
                                onTap: () => unFavorite(index),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
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

                      // By default, show a loading spinner.
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: CircularProgressIndicator()
                        ),
                      );
                    },
                  );
                },
              ),
      )
    );
  }
}

Widget _emptyMessage() {
  return const Center(
    child: Text('The list is empty!', style: AppStyle.h3,),
  );
}