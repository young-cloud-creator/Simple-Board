import 'dart:math';
import 'package:flutter/material.dart';

class Pointer {
  Pointer._constructor() {
    rangePaint.isAntiAlias = true;
    rangePaint.style = PaintingStyle.fill;
    rangePaint.color = Colors.black12;
  }
  static final Pointer instance = Pointer._constructor();
  Paint rangePaint = Paint();
  Offset? startPoint;
  Offset? endPoint;

  void startDrag(Offset point) {
    startPoint = point;
  }

  void updateDrag(Offset point) {
    endPoint = point;
  }

  void endDrag() {
    startPoint = null;
    endPoint = null;
  }

  void draw(Canvas canvas, Size size) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    canvas.drawRect(Rect.fromPoints(startPoint!, endPoint!), rangePaint);
  }

  bool exists() {
    return startPoint != null && endPoint != null;
  }

  (Offset, Offset) getPoints() {
    final rect = Rect.fromPoints(startPoint!, endPoint!);
    return (rect.topLeft, rect.bottomRight);
  }
}

abstract class ShapeComponent {
  Offset? startPoint;
  Offset? endPoint;
  Offset? topLeft;
  Offset? bottomRight;
  bool isSelected = false;
  final boundingBoxPaint = Paint();

  Offset? oldStart;
  Offset? oldEnd;

  ShapeComponent() {
    boundingBoxPaint.color = Colors.blueAccent;
    boundingBoxPaint.style = PaintingStyle.stroke;
    boundingBoxPaint.strokeWidth = 1.5;
  }

  void startBuild(Offset point) {
    startPoint = point;
    topLeft = point;
    bottomRight = point;
  }

  void updateDst(Offset point) {
    endPoint = point;
    bottomRight = point;
  }

  bool isInRect(Offset leftTop, Offset rightBottom) {
    if (topLeft == null || bottomRight == null) {
      return false;
    }
    final selfCenter = Offset((topLeft!.dx + bottomRight!.dx) / 2,
        (topLeft!.dy + bottomRight!.dy) / 2);
    final rectCenter = Offset(
        (leftTop.dx + rightBottom.dx) / 2, (leftTop.dy + rightBottom.dy) / 2);
    final selfWidth = (topLeft!.dx - bottomRight!.dx).abs();
    final rectWidth = (leftTop.dx - rightBottom.dx).abs();
    final selfHeight = (topLeft!.dy - bottomRight!.dy).abs();
    final rectHeight = (leftTop.dy - rightBottom.dy).abs();
    final xFlag =
        (selfCenter.dx - rectCenter.dx).abs() < selfWidth / 2 + rectWidth / 2;
    final yFlag =
        (selfCenter.dy - rectCenter.dy).abs() < selfHeight / 2 + rectHeight / 2;
    return xFlag && yFlag;
  }

  void drawBoundingBox(Canvas canvas, Size size) {
    if (topLeft == null || bottomRight == null) {
      return;
    }
    canvas.drawRect(Rect.fromPoints(topLeft!, bottomRight!), boundingBoxPaint);
  }

  ShapeComponent deepCopy();

  void saveOldPos() {
    oldStart = Offset(startPoint!.dx, startPoint!.dy);
    oldEnd = Offset(endPoint!.dx, endPoint!.dy);
  }

  void moveToNewPos(Offset offset) {
    if (oldStart == null || oldEnd == null) {
      return;
    }
    startPoint = Offset(oldStart!.dx + offset.dx, oldStart!.dy + offset.dy);
    endPoint = Offset(oldEnd!.dx + offset.dx, oldEnd!.dy + offset.dy);
    topLeft = startPoint;
    bottomRight = endPoint;
  }

  void draw(Canvas canvas, Size size, Paint paint);
}

class LineComponent extends ShapeComponent {
  @override
  ShapeComponent deepCopy() {
    LineComponent newObj = LineComponent();
    if (startPoint != null) {
      newObj.startPoint = Offset(startPoint!.dx, startPoint!.dy);
    }
    if (endPoint != null) {
      newObj.endPoint = Offset(endPoint!.dx, endPoint!.dy);
    }
    if (topLeft != null) {
      newObj.topLeft = Offset(topLeft!.dx, topLeft!.dy);
    }
    if (bottomRight != null) {
      newObj.bottomRight = Offset(bottomRight!.dx, bottomRight!.dy);
    }
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    canvas.drawLine(startPoint!, endPoint!, paint);
  }
}

class RectComponent extends ShapeComponent {
  @override
  ShapeComponent deepCopy() {
    final newObj = RectComponent();
    if (startPoint != null) {
      newObj.startPoint = Offset(startPoint!.dx, startPoint!.dy);
    }
    if (endPoint != null) {
      newObj.endPoint = Offset(endPoint!.dx, endPoint!.dy);
    }
    if (topLeft != null) {
      newObj.topLeft = Offset(topLeft!.dx, topLeft!.dy);
    }
    if (bottomRight != null) {
      newObj.bottomRight = Offset(bottomRight!.dx, bottomRight!.dy);
    }
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    canvas.drawRect(Rect.fromPoints(startPoint!, endPoint!), paint);
  }
}

class CircleComponent extends ShapeComponent {
  @override
  ShapeComponent deepCopy() {
    final newObj = CircleComponent();
    if (startPoint != null) {
      newObj.startPoint = Offset(startPoint!.dx, startPoint!.dy);
    }
    if (endPoint != null) {
      newObj.endPoint = Offset(endPoint!.dx, endPoint!.dy);
    }
    if (topLeft != null) {
      newObj.topLeft = Offset(topLeft!.dx, topLeft!.dy);
    }
    if (bottomRight != null) {
      newObj.bottomRight = Offset(bottomRight!.dx, bottomRight!.dy);
    }
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    final centerPoint = Offset((startPoint!.dx + endPoint!.dx) / 2,
        (startPoint!.dy + endPoint!.dy) / 2);
    num radius = (pow(startPoint!.dx - endPoint!.dx, 2)) +
        pow((startPoint!.dy - endPoint!.dy), 2);
    radius = sqrt(radius) / 2;
    canvas.drawCircle(centerPoint, radius.toDouble(), paint);

    topLeft = Offset(centerPoint.dx - radius, centerPoint.dy - radius);
    bottomRight = Offset(centerPoint.dx + radius, centerPoint.dy + radius);
  }
}

class TriangleComponent extends ShapeComponent {
  Offset? thirdPoint;
  Offset? oldThird;

  @override
  ShapeComponent deepCopy() {
    final newObj = TriangleComponent();
    if (startPoint != null) {
      newObj.startPoint = Offset(startPoint!.dx, startPoint!.dy);
    }
    if (endPoint != null) {
      newObj.endPoint = Offset(endPoint!.dx, endPoint!.dy);
    }
    if (thirdPoint != null) {
      newObj.thirdPoint = Offset(thirdPoint!.dx, thirdPoint!.dy);
    }
    if (topLeft != null) {
      newObj.topLeft = Offset(topLeft!.dx, topLeft!.dy);
    }
    if (bottomRight != null) {
      newObj.bottomRight = Offset(bottomRight!.dx, bottomRight!.dy);
    }
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null || thirdPoint == null) {
      return;
    }
    canvas.drawLine(startPoint!, endPoint!, paint);
    canvas.drawLine(endPoint!, thirdPoint!, paint);
    canvas.drawLine(thirdPoint!, startPoint!, paint);
  }

  @override
  void updateDst(Offset point) {
    endPoint = point;
    final centerPoint = Offset((startPoint!.dx + endPoint!.dx) / 2,
        (startPoint!.dy + endPoint!.dy) / 2);
    num sideLen = pow(startPoint!.dx - endPoint!.dx, 2) +
        pow((startPoint!.dy - endPoint!.dy), 2);
    sideLen = sqrt(sideLen);

    double posX, posY;
    if ((startPoint!.dx - endPoint!.dx).abs() < 0.001) {
      posY = centerPoint.dy;
      posX = startPoint!.dx + tan(pi / 3) * sideLen / 2;
    } else if ((startPoint!.dy - endPoint!.dy).abs() < 0.001) {
      posX = centerPoint.dx;
      posY = startPoint!.dy + tan(pi / 3) * sideLen / 2;
    } else {
      final xDiff = (startPoint!.dx - endPoint!.dx).abs();
      final yDiff = (startPoint!.dy - endPoint!.dy).abs();
      final temp = atan2(xDiff, yDiff);
      final middleLine = tan(pi / 3) * sideLen / 2;
      posX = middleLine * (cos(temp).abs()) + centerPoint.dx;
      posY = middleLine * (sin(temp).abs()) + centerPoint.dy;
    }
    thirdPoint = Offset(posX, posY);

    topLeft = Offset(min(thirdPoint!.dx, min(startPoint!.dx, endPoint!.dx)),
        min(thirdPoint!.dy, min(startPoint!.dy, endPoint!.dy)));
    bottomRight = Offset(max(thirdPoint!.dx, max(startPoint!.dx, endPoint!.dx)),
        max(thirdPoint!.dy, max(startPoint!.dy, endPoint!.dy)));
  }

  @override
  void saveOldPos() {
    super.saveOldPos();
    oldThird = Offset(thirdPoint!.dx, thirdPoint!.dy);
  }

  @override
  void moveToNewPos(Offset offset) {
    super.moveToNewPos(offset);
    if (oldThird == null) {
      return;
    }
    thirdPoint = Offset(oldThird!.dx + offset.dx, oldThird!.dy + offset.dy);
    topLeft = Offset(min(thirdPoint!.dx, min(startPoint!.dx, endPoint!.dx)),
        min(thirdPoint!.dy, min(startPoint!.dy, endPoint!.dy)));
    bottomRight = Offset(max(thirdPoint!.dx, max(startPoint!.dx, endPoint!.dx)),
        max(thirdPoint!.dy, max(startPoint!.dy, endPoint!.dy)));
  }
}

class OvalComponent extends ShapeComponent {
  @override
  ShapeComponent deepCopy() {
    final newObj = OvalComponent();
    if (startPoint != null) {
      newObj.startPoint = Offset(startPoint!.dx, startPoint!.dy);
    }
    if (endPoint != null) {
      newObj.endPoint = Offset(endPoint!.dx, endPoint!.dy);
    }
    if (topLeft != null) {
      newObj.topLeft = Offset(topLeft!.dx, topLeft!.dy);
    }
    if (bottomRight != null) {
      newObj.bottomRight = Offset(bottomRight!.dx, bottomRight!.dy);
    }
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    canvas.drawOval(Rect.fromPoints(startPoint!, endPoint!), paint);
  }
}

class PencilComponent extends ShapeComponent {
  final points = <Offset>[];
  List<Offset>? oldPoints;
  Offset? oldTopLeft;
  Offset? oldBottomRight;

  @override
  ShapeComponent deepCopy() {
    final newObj = PencilComponent();
    newObj.points.addAll(points);
    if (topLeft != null) {
      newObj.topLeft = Offset(topLeft!.dx, topLeft!.dy);
    }
    if (bottomRight != null) {
      newObj.bottomRight = Offset(bottomRight!.dx, bottomRight!.dy);
    }
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < points.length - 1; ++i) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  void startBuild(Offset point) {
    super.startBuild(point);
    points.add(point);
  }

  @override
  void updateDst(Offset point) {
    endPoint = point;
    topLeft = Offset(min(point.dx, topLeft!.dx), min(point.dy, topLeft!.dy));
    bottomRight =
        Offset(max(point.dx, bottomRight!.dx), max(point.dy, bottomRight!.dy));
    points.add(point);
  }

  @override
  void saveOldPos() {
    oldTopLeft = topLeft;
    oldBottomRight = bottomRight;
    oldPoints = List.from(points.map((e) => Offset(e.dx, e.dy)));
  }

  @override
  void moveToNewPos(Offset offset) {
    if (oldPoints == null || oldTopLeft == null || oldBottomRight == null) {
      return;
    }
    points.clear();
    points.addAll(
        oldPoints!.map((p) => Offset(p.dx + offset.dx, p.dy + offset.dy)));
    topLeft = Offset(oldTopLeft!.dx + offset.dx, oldTopLeft!.dy + offset.dy);
    bottomRight =
        Offset(oldBottomRight!.dx + offset.dx, oldBottomRight!.dy + offset.dy);
  }
}

class TextComponent extends ShapeComponent {
  final _textPainter = TextPainter();

  TextComponent() : super() {
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.text = const TextSpan(
        text: "The quick brown fox jumps over the lazy dog",
        style: TextStyle(color: Colors.black));
    _textPainter.layout(minWidth: 5.0);
  }

  void setText(String text) {
    _textPainter.text =
        TextSpan(text: text, style: const TextStyle(color: Colors.black));
    _textPainter.layout(minWidth: 5.0);
  }

  @override
  ShapeComponent deepCopy() {
    final newObj = TextComponent();
    if (startPoint != null) {
      newObj.startPoint = Offset(startPoint!.dx, startPoint!.dy);
    }
    if (endPoint != null) {
      newObj.endPoint = Offset(endPoint!.dx, endPoint!.dy);
    }
    if (topLeft != null) {
      newObj.topLeft = Offset(topLeft!.dx, topLeft!.dy);
    }
    if (bottomRight != null) {
      newObj.bottomRight = Offset(bottomRight!.dx, bottomRight!.dy);
    }
    newObj._textPainter.textDirection = _textPainter.textDirection;
    newObj._textPainter.text = _textPainter.text;
    newObj._textPainter.layout(minWidth: 5.0);
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    _textPainter.layout(
        minWidth: 5.0, maxWidth: max(size.width - endPoint!.dx, 5.0));
    _textPainter.paint(canvas, endPoint!);
  }

  @override
  void startBuild(Offset point) {
    startPoint = point;
  }

  @override
  void updateDst(Offset point) {
    endPoint = point;
    topLeft = point;
    bottomRight = Offset(
        topLeft!.dx + _textPainter.width, topLeft!.dy + _textPainter.height);
  }

  @override
  void drawBoundingBox(Canvas canvas, Size size) {
    bottomRight = Offset(
        topLeft!.dx + _textPainter.width, topLeft!.dy + _textPainter.height);
    super.drawBoundingBox(canvas, size);
  }

  @override
  void moveToNewPos(Offset offset) {
    super.moveToNewPos(offset);
    topLeft = endPoint;
    bottomRight = Offset(
        topLeft!.dx + _textPainter.width, topLeft!.dy + _textPainter.height);
  }
}
