import 'package:flutter/material.dart';
import '../core/colors.dart';

class PixelFrame extends StatelessWidget {
  final Widget child;
  final double padding;

  const PixelFrame({required this.child, this.padding = 8, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: PBColors.deepBlack,
        border: Border.all(width: 6, color: Colors.black),
        boxShadow: const [
          BoxShadow(color: PBColors.pixelShadow, offset: Offset(4, 4), blurRadius: 0)
        ],
      ),
      child: child,
    );
  }
}
