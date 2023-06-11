import 'package:flutter/material.dart';
import 'package:flutter_app/models/english_word.dart';
import 'package:flutter_app/utils/db.dart';
import 'package:flutter_app/utils/style.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final ScrollController _scrollController = ScrollController();
  List<EnglishWord> list = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      list = EnglishWord.getFavorite();
    });
  }

  void unFavorite(int index) {
    if (list[index].noun != null) {
      final String noun = list[index].noun!;
      Set<String> favorites = (DB.prefs.getStringList(DB.favorites) ?? []).toSet();
      favorites.remove(noun);
      DB.prefs.setStringList(DB.favorites, favorites.toList());
    }

    setState(() {
      list.removeAt(index);
    });
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
                  EnglishWord word = list[index];
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