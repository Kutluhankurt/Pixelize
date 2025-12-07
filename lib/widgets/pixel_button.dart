import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/pixel_fonts.dart';

class PixelButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;

  const PixelButton({required this.text, required this.onTap, this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: PBColors.bananaYellow,
          border: Border.all(width: 4, color: Colors.black),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: PixelFonts.title,
              fontSize: 12,
              color: PBColors.deepBlack,
            ),
          ),
        ),
      ),
    );
  }
}
