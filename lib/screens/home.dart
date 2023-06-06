import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_app/models/english_word.dart";
import "package:flutter_app/ultils/style.dart";
import 'package:english_words/english_words.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  late PageController _pageController;
  late String quote;

  List <EnglishWord> words = [];

  getList() {
    final random = Random();

    int start = random.nextInt(1000) + 1;
    int end = start + 5;

    Iterable<String> items = nouns.getRange(start, end);

    return items.map((h) => EnglishWord(
      id: h,
        letter: h.substring(0, 1).toUpperCase(),
        after: h.substring(1),
        noun: h,
        quote: getQuote()
    )).toList();
  }

  getQuote() {
    final random = Random();
    int start = random.nextInt(500) + 1;
    int length = random.nextInt(15) + 8;
    int end = start + length;

    String string = nouns.getRange(start, end).join(' ');

    return string.substring(0, 1).toUpperCase() + string.substring(1);
  }

  suffle() {
    double? page = _pageController.page;
    int duration = page != null ? 100 * max(page.toInt(), 1) : 200;

    _pageController.animateToPage(0, curve: Curves.decelerate, duration: Duration(milliseconds: duration));
    setState(() {
      _currentPage = 0;
      words = getList();
      quote = getQuote();
    });
  }

  @override
  void initState() {
    words = getList();
    quote = getQuote();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.secondColor,
      appBar: AppBar(
        backgroundColor: AppStyle.secondColor,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.format_align_right_outlined,
              color: AppStyle.textColor, size: 38),
        ),
        title: Text('English today',
            textAlign: TextAlign.left,
            style: AppStyle.h3.copyWith(
              color: AppStyle.textColor,
            )),
      ),
      body: SizedBox(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  height: 94,
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                    text: TextSpan(
                      text: '"$quote"',
                      style: AppStyle.h5.copyWith(color: AppStyle.textColor))
                    ),
                  ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        decoration: const BoxDecoration(
                            color: AppStyle.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 3),
                                  blurRadius: 4)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.heart_broken,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: words[index].letter,
                                  style: AppStyle.h1.copyWith(
                                      height: 1,
                                      shadows: [
                                        const BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(3, 6),
                                            blurRadius: 6)
                                      ]),
                                  children: [
                                    TextSpan(
                                        text: words[index].after,
                                        style: AppStyle.h3.copyWith(
                                            fontSize: 54, shadows: []))
                                  ]),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                    // '"Think of all the beauty still left around you and be happy."',
                                    '"${words[index].quote}"',
                                    style: AppStyle.h4.copyWith(
                                        fontSize: 22,
                                        color: AppStyle.textColor,
                                        letterSpacing: 0.8)))
                          ],
                        ));
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                margin: const EdgeInsets.only(bottom: 110),
                height: 20,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return buildIndicator(index == _currentPage);
                  },
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => suffle(),
        backgroundColor: AppStyle.primaryColor,
        child: const Icon(Icons.sync_rounded, color: Colors.black54),
      ),
    );
  }
}

Widget buildIndicator(bool isActive) {
  return Container(
    margin: const EdgeInsets.only(top: 0, bottom: 12, left: 10, right: 10),
    width: isActive ? 100 : 25,
    decoration: BoxDecoration(
        color: isActive ? AppStyle.primaryColor : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 2)
        ]),
  );
}
