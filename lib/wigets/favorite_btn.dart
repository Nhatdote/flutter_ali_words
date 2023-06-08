import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class FavoriteBtn extends StatelessWidget {
  final GestureTapCallback onToggleFavorite;
  final bool isFavorite;

  const FavoriteBtn({super.key, required this.isFavorite, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      mainAxisAlignment: MainAxisAlignment.end,
      onTap: (isLiked) async {
        onToggleFavorite();
        return !isLiked;
      },
      isLiked: isFavorite,
      size: 48,
      circleColor: const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite_rounded,
          color: isLiked ? Colors.red : Colors.white,
          size: 48,
        );
      },
    );
  }
}