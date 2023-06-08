import 'package:flutter/material.dart';
import 'package:flutter_app/models/english_word.dart';
import 'package:flutter_app/wigets/favorite_btn.dart';
import '../ultils/style.dart';


class EnglishCard extends StatefulWidget {
  final EnglishWord word;

  const EnglishCard({super.key, required this.word});

  @override
  State<EnglishCard> createState() => _EnglishCardState();
}

class _EnglishCardState extends State<EnglishCard> {
  
  @override
  Widget build(BuildContext context) {
    final EnglishWord word = widget.word;
    // final GlobalKey<LikeButtonState> likeButtonKey = GlobalKey<LikeButtonState>();

    toggle() {
      setState(() {
        word.isFavorite = !word.isFavorite;
      });
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        
        child: Material(
          color: AppStyle.primaryColor,
          elevation: 6,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            onDoubleTap:() => toggle(),
            splashColor: Colors.transparent,
            focusColor: Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FavoriteBtn(isFavorite: word.isFavorite, onToggleFavorite: () => word.isFavorite = !word.isFavorite),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: word.letter,
                        style: AppStyle.h1.copyWith(height: 1, shadows: [
                          const BoxShadow(
                              color: Colors.black38,
                              offset: Offset(3, 6),
                              blurRadius: 6)
                        ]),
                        children: [
                          TextSpan(
                              text: word.after,
                              style: AppStyle.h3.copyWith(fontSize: 54, shadows: []))
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                      child: SingleChildScrollView(
                          child: Text(
                        '"${word.quote}"',
                        style: const TextStyle(fontSize: 20, letterSpacing: 0.5),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}