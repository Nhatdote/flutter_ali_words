import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_ali_words/models/english_word.dart";
import "package:flutter_ali_words/screens/all_words.dart";
import "package:flutter_ali_words/screens/favorite.dart";
import "package:flutter_ali_words/screens/setting.dart";
import 'package:flutter_ali_words/utils/db.dart';
import 'package:flutter_ali_words/utils/style.dart';
import "package:flutter_ali_words/wigets/drawer_btn.dart";
import "package:flutter_ali_words/wigets/english_card.dart";
import "package:flutter_ali_words/wigets/indicator.dart";
import "package:flutter_ali_words/wigets/showmore_card.dart";
import "package:flutter_ali_words/wigets/skeleton.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late ScrollController indicatorController;

  late String quote = "";
  late int _currentPage = 0;
  late List<Future<EnglishWord>> words = [];
  bool shuffling = false;

  void shuffle() async {
    double? page = _pageController.page;
    int duration = page != null ? 100 * max(page.toInt(), 1) : 200;

    _pageController.animateToPage(0,
        curve: Curves.decelerate, duration: Duration(milliseconds: duration));
      
    setState(() {
      shuffling = true;
    });

    await defaultState();

    setState(() {
      shuffling = false;
    });
  }

  Future<void> defaultState() async {
    int perPage = DB.prefs.getInt(DB.perPage) ?? 5;

    List<Future<EnglishWord>> list = EnglishWord.getList(perPage);

    await Future.wait(list);

    setState(() {
        _currentPage = 0;
        words = list;
        quote = EnglishWord.getQuote();
      });
  }

  updateFavorite() {
    Set<String> favorites = (DB.prefs.getStringList(DB.favorites) ?? []).toSet();

    setState(() {
      words = words.map((w) {
        return w.then((h) {
          h.isFavorite = favorites.contains(h.noun);
          return h;
        });
      }).toList();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    indicatorController = ScrollController();

    super.initState();

    defaultState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldState,
      backgroundColor: AppStyle.secondColor,
      appBar: AppBar(
        backgroundColor: AppStyle.secondColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            _scaffoldState.currentState?.openDrawer();
          },
          child: const Icon(Icons.format_align_right_outlined,
              color: AppStyle.textColor, size: 38),
        ),
        title: Text('English today',
            textAlign: TextAlign.left,
            style: AppStyle.h3.copyWith(
              color: AppStyle.textColor,
            )),
      ),
      drawer: Drawer(
          child: Container(
        color: AppStyle.primaryColor,
        child: SafeArea(
            child: Column(
          children: [
            Container(
              height: screenHeight * 1 / 6,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.centerLeft,
              child: Text(
                'Your mind',
                style: AppStyle.h3.copyWith(color: AppStyle.textColor),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DrawerBtn(
                      label: 'Favorites',
                      onTap: () async {
                        _scaffoldState.currentState?.closeDrawer();
                        await Navigator.push(context, 
                          MaterialPageRoute(builder: (_) => const FavoritePage()));

                        updateFavorite();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 44),
                  child: DrawerBtn(
                      label: 'All words',
                      onTap: () {
                        _scaffoldState.currentState?.closeDrawer();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const AllWords()));
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 44),
                  child: DrawerBtn(
                      label: 'Settings',
                      onTap: () async {
                        _scaffoldState.currentState?.closeDrawer();
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Setting()));

                        shuffle();
                      }),
                ),
              ],
            ))
          ],
        )),
      )),
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
                    style: AppStyle.h5.copyWith(color: AppStyle.textColor))),
          ),
          Expanded(
            child: words.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    double maxScroll = indicatorController.position.maxScrollExtent;

                    if (maxScroll > 0) {
                      double jump = (index - 1) * 45;
                      jump = min(jump, maxScroll);

                      indicatorController.animateTo(jump,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInCubic);
                    }

                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: words.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= 0 && index < words.length) {
                      return FutureBuilder<EnglishWord>(
                        future: words[index],
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final EnglishWord word = snapshot.data!;
                            return EnglishCard(word: word);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    } else {
                      return const ShowmoreCard();
                    }
                  },
                ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            margin: const EdgeInsets.only(bottom: 110),
            height: 30,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: indicatorController,
              scrollDirection: Axis.horizontal,
              itemCount: words.length + 1,
              itemBuilder: (context, index) {
                String label = index >= words.length ? '+' : (index + 1).toString();
                return Indicator(index: label, isActive: index == _currentPage);
              },
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => shuffle(),
        backgroundColor: AppStyle.primaryColor,
        child: shuffling 
          ? const SizedBox(
            width: 20,
            height: 20,
            child:  CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.redAccent,
            ),
          )
          : const Icon(Icons.sync_rounded, color: Colors.black54)
      ),
    );
  }
}
