import 'package:flutter/material.dart';

class StarShapeBorder extends ShapeBorder {
  final Path _path = Path();

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) =>
      nStarPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  Path nStarPath(Rect rect) {
    _path.addRRect(RRect.fromLTRBR(
        rect.left, rect.top, rect.right, rect.bottom - 3, Radius.circular(10)));
    _path.moveTo(rect.right / 2, rect.bottom);
    _path.lineTo(rect.right / 2 + 3, rect.bottom - 3);
    _path.lineTo(rect.right / 2 - 3, rect.bottom - 3);
    _path.close();
    return _path;
  }

  @override
  ShapeBorder scale(double t) {
    return null;
  }
}
