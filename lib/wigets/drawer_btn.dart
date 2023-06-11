import "package:flutter/material.dart";
import 'package:flutter_app/utils/style.dart';

class DrawerBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DrawerBtn({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      shadowColor: Colors.black54,
      elevation: 8,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(label, 
            style: AppStyle.h5.copyWith(color: AppStyle.textColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}