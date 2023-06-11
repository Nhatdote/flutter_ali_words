import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_app/models/english_word.dart";
import "package:flutter_app/screens/all_words.dart";
import "package:flutter_app/screens/favorite.dart";
import "package:flutter_app/screens/setting.dart";
import "package:flutter_app/ultils/db_keys.dart";
import "package:flutter_app/ultils/style.dart";
import "package:flutter_app/wigets/drawer_btn.dart";
import "package:flutter_app/wigets/english_card.dart";
import "package:flutter_app/wigets/indicator.dart";
import "package:flutter_app/wigets/showmore_card.dart";
import "package:shared_preferences/shared_preferences.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late ScrollController indicatorController;
  late SharedPreferences prefs;

  late String quote = "";
  late int _currentPage = 0;

  List<EnglishWord> words = [];

  suffle() {
    double? page = _pageController.page;
    int duration = page != null ? 100 * max(page.toInt(), 1) : 200;

    _pageController.animateToPage(0,
        curve: Curves.decelerate, duration: Duration(milliseconds: duration));

    defaultState();
  }

  defaultState() async {
    prefs = await SharedPreferences.getInstance();
    int perPage = prefs.getInt(DBKeys.perPage) ?? 5;
    List<EnglishWord> list = await EnglishWord.getList(perPage);

    setState(() {
      _currentPage = 0;
      words = list;
      quote = EnglishWord.getQuote();
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
                      onTap: () {
                        _scaffoldState.currentState?.closeDrawer();
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (_) => const FavoritePage()));
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
                      onTap: () {
                        _scaffoldState.currentState?.closeDrawer();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Setting()));
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
            child: PageView.builder(
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
                  return EnglishCard(word: words[index]);
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
        onPressed: () => suffle(),
        backgroundColor: AppStyle.primaryColor,
        child: const Icon(Icons.sync_rounded, color: Colors.black54),
      ),
    );
  }
}
