import 'package:flutter/material.dart';
import 'package:flutter_app/models/english_word.dart';
import 'package:flutter_app/ultils/style.dart';

class AllWords extends StatefulWidget {
  const AllWords({super.key});

  @override
  State<AllWords> createState() => _AllWordsState();
}

class _AllWordsState extends State<AllWords> {
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
                    child: ListTile(
                      leading: Icon(
                        Icons.favorite,
                        color: word.isFavorite ? Colors.red : Colors.white,
                      ),
                      title: Text(label, style: AppStyle.h4.copyWith(color: AppStyle.textColor)),
                      subtitle: Text(word.quote ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 14)),
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