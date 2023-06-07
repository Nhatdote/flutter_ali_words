import "dart:ffi";
import "dart:math";
import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_app/models/english_word.dart";
import "package:flutter_app/screens/setting.dart";
import "package:flutter_app/ultils/db_keys.dart";
import "package:flutter_app/ultils/style.dart";
import 'package:english_words/english_words.dart';
import "package:flutter_app/wigets/drawer_btn.dart";
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

  Map<int, bool> scrollEnds = {};
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

    setState(() {
      _currentPage = 0;
      scrollEnds = {};
      words = EnglishWord.getList(perPage);
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Setting()));
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
                double jump = maxScroll / 2;

                // jump = min(jump, 100);

                indicatorController.animateTo(jump, 
                  duration: const Duration(milliseconds: 300), 
                  curve: Curves.easeInCubic
                );

                print(jump);

                // print("offset ${indicatorController.position.maxScrollExtent}, move ${index * 25}");

                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: const BoxDecoration(
                        color: AppStyle.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
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
                              style: AppStyle.h1.copyWith(height: 1, shadows: [
                                const BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(3, 6),
                                    blurRadius: 6)
                              ]),
                              children: [
                                TextSpan(
                                    text: words[index].after,
                                    style: AppStyle.h3
                                        .copyWith(fontSize: 54, shadows: []))
                              ]),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 16),
                            child: SingleChildScrollView(
                                    child: Text(
                                  '"${words[index].quote}"',
                                  style: const TextStyle(
                                      fontSize: 20, letterSpacing: 0.5),
                                )),
                          ),
                        )
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
              controller: indicatorController,
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
