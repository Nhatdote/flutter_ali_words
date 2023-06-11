import 'package:flutter/material.dart';
import 'package:flutter_ali_words/utils/style.dart';

class Indicator extends StatelessWidget {
  final String index;
  final bool isActive;

  const Indicator({super.key, required this.index, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInCubic,
          margin: const EdgeInsets.only(top: 0, bottom: 2, left: 10, right: 10),
          width: isActive ? 70 : 25,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppStyle.primaryColor : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 2)
            ]
          )
        ),
        Container(
          alignment: Alignment.center,
          height: 20,
          child: Text(index, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppStyle.textGrey)),
        )
      ],
    );
  }
}