import 'package:flutter/material.dart';
import '../core/colors.dart';

class PixelLoader extends StatelessWidget {
  final double progress; // 0..1

  const PixelLoader({required this.progress, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final filled = (width * progress).clamp(0.0, width);
    return Container(
      width: width,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(width: 4, color: Colors.black),
      ),
      child: Stack(
        children: [
          Container(
            width: filled,
            height: 18,
            color: PBColors.bananaYellow,
          ),
        ],
      ),
    );
  }
}
