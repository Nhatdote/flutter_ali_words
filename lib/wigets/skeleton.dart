import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class Skeleton extends StatelessWidget {
  static const card = 'card';
  static const list = 'list';

  final int length;
  final String? type;

  const Skeleton({super.key, required this.length, this.type = list});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 6, left: 2),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12,
              ),
            ),
            const SizedBox(width: 34),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: Random().nextInt(75) + 100,
                    height: 22,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        width: double.infinity,
                        height: 11,
                        color: Colors.white,
                      ),
                      Container(
                        width: Random().nextInt(150) + 150,
                        height: 11,
                        color: Colors.white,
                      ),
                    ],
                  )
                  
                ],
              ),
            ),
          ],
        ),
      ),
      items: length,
      period: const Duration(seconds: 2),
      highlightColor: Colors.black12,
      direction: SkeletonDirection.ltr,
    );
  }
}