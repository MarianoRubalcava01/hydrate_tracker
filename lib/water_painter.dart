import 'package:flutter/material.dart';

class WaterPainter extends CustomPainter {
  final double progress;

  WaterPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(150, 100, 171, 229) // Adjust opacity here
      ..style = PaintingStyle.fill;

    final fillHeight = size.height * progress;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - fillHeight, size.width, fillHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant WaterPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}