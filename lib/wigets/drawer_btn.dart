import "package:flutter/material.dart";
import "package:flutter_app/ultils/style.dart";

class DrawerBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DrawerBtn({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 6),
              blurRadius: 3
            )
          ]
        ),
        child: Text(label, 
          style: AppStyle.h5.copyWith(color: AppStyle.textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}