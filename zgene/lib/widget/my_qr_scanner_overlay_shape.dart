import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MyQrScannerOverlayShape extends QrScannerOverlayShape {
  var image;

  MyQrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
    this.cutOutTopOffset = 0,
    this.image,
  }) : assert(borderLength <= cutOutSize / 2 + borderWidth * 2,
            "Border can't be larger than ${cutOutSize / 2 + borderWidth * 2}");

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;
  final double cutOutTopOffset;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _borderLength = borderLength > cutOutSize / 2 + borderWidth * 2
        ? borderWidthSize / 2
        : borderLength;
    final _cutOutSize = cutOutSize < width ? cutOutSize : width - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutSize / 2 + borderOffset,
      cutOutTopOffset + rect.top + borderOffset,
      _cutOutSize - borderOffset * 2,
      _cutOutSize - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // // Draw top right corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.right - _borderLength,
      //     cutOutRect.top,
      //     cutOutRect.right,
      //     cutOutRect.top + _borderLength,
      //     topRight: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw top left corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.left,
      //     cutOutRect.top,
      //     cutOutRect.left + _borderLength,
      //     cutOutRect.top + _borderLength,
      //     topLeft: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw bottom right corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.right - _borderLength,
      //     cutOutRect.bottom - _borderLength,
      //     cutOutRect.right,
      //     cutOutRect.bottom,
      //     bottomRight: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw bottom left corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.left,
      //     cutOutRect.bottom - _borderLength,
      //     cutOutRect.left + _borderLength,
      //     cutOutRect.bottom,
      //     bottomLeft: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();

    if (null != image) {
      canvas
        ..drawImageRect(
            image,
            Rect.fromCenter(
                center: Offset(image.width / 2, image.height / 2),
                width: image.width * 1.0,
                height: image.width * 1.0),
            Rect.fromLTRB(cutOutRect.left - 7, cutOutRect.top - 7,
                cutOutRect.right + 8, cutOutRect.bottom + 8),
            borderPaint)
        ..restore();
    }
  }

  @override
  ShapeBorder scale(double t) {
    return MyQrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}