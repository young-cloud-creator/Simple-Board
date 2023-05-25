import 'dart:math';
import 'package:flutter/material.dart';

abstract class ShapeComponent {
  Offset? startPoint;
  Offset? endPoint;

  void startBuild(Offset point) {
    startPoint = point;
  }

  void updateDst(Offset point) {
    endPoint = point;
  }

  bool isInRect(Offset leftTop, Offset rightBottom);
  void drawBoundingBox();
  void eraseBoundingBox();
  ShapeComponent deepCopy();
  void moveToNewPos(Offset offset) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    startPoint = Offset(startPoint!.dx + offset.dx, startPoint!.dy + offset.dy);
    endPoint = Offset(endPoint!.dx + offset.dx, endPoint!.dy + offset.dy);
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
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    canvas.drawLine(startPoint!, endPoint!, paint);
  }

  @override
  void drawBoundingBox() {
    // TODO: implement drawBoundingBox
  }

  @override
  void eraseBoundingBox() {
    // TODO: implement eraseBoundingBox
  }

  @override
  bool isInRect(Offset leftTop, Offset rightBottom) {
    // TODO: implement isInRect
    throw UnimplementedError();
  }

  @override
  void moveToNewPos(Offset offset) {
    // TODO: implement moveToNewPos
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
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    canvas.drawRect(Rect.fromPoints(startPoint!, endPoint!), paint);
  }

  @override
  void drawBoundingBox() {
    // TODO: implement drawBoundingBox
  }

  @override
  void eraseBoundingBox() {
    // TODO: implement eraseBoundingBox
  }

  @override
  bool isInRect(Offset leftTop, Offset rightBottom) {
    // TODO: implement isInRect
    throw UnimplementedError();
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
  }

  @override
  void drawBoundingBox() {
    // TODO: implement drawBoundingBox
  }

  @override
  void eraseBoundingBox() {
    // TODO: implement eraseBoundingBox
  }

  @override
  bool isInRect(Offset leftTop, Offset rightBottom) {
    // TODO: implement isInRect
    throw UnimplementedError();
  }
}

class TriangleComponent extends ShapeComponent {
  Offset? thirdPoint;

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
    super.updateDst(point);

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
  }

  @override
  void drawBoundingBox() {
    // TODO: implement drawBoundingBox
  }

  @override
  void eraseBoundingBox() {
    // TODO: implement eraseBoundingBox
  }

  @override
  bool isInRect(Offset leftTop, Offset rightBottom) {
    // TODO: implement isInRect
    throw UnimplementedError();
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
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    canvas.drawOval(Rect.fromPoints(startPoint!, endPoint!), paint);
  }

  @override
  void drawBoundingBox() {
    // TODO: implement drawBoundingBox
  }

  @override
  void eraseBoundingBox() {
    // TODO: implement eraseBoundingBox
  }

  @override
  bool isInRect(Offset leftTop, Offset rightBottom) {
    // TODO: implement isInRect
    throw UnimplementedError();
  }
}

class PencilComponent extends ShapeComponent {
  final points = <Offset>[];

  @override
  ShapeComponent deepCopy() {
    final newObj = PencilComponent();
    newObj.points.addAll(points);
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
    points.add(point);
  }

  @override
  void updateDst(Offset point) {
    points.add(point);
  }

  @override
  void drawBoundingBox() {
    // TODO: implement drawBoundingBox
  }

  @override
  void eraseBoundingBox() {
    // TODO: implement eraseBoundingBox
  }

  @override
  bool isInRect(Offset leftTop, Offset rightBottom) {
    // TODO: implement isInRect
    throw UnimplementedError();
  }
}

class TextComponent extends ShapeComponent {
  final _textPainter = TextPainter();

  TextComponent() {
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.text = const TextSpan(
        text: "The quick brown fox jumps over the lazy dog",
        style: TextStyle(color: Colors.black));
  }

  void setText(String text) {
    _textPainter.text =
        TextSpan(text: text, style: const TextStyle(color: Colors.black));
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
    newObj._textPainter.text = _textPainter.text;
    return newObj;
  }

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    if (startPoint == null || endPoint == null) {
      return;
    }
    _textPainter.layout(minWidth: 5.0, maxWidth: size.width - endPoint!.dx);
    _textPainter.paint(canvas, endPoint!);
  }

  @override
  void drawBoundingBox() {
    // TODO: implement drawBoundingBox
  }

  @override
  void eraseBoundingBox() {
    // TODO: implement eraseBoundingBox
  }

  @override
  bool isInRect(Offset leftTop, Offset rightBottom) {
    // TODO: implement isInRect
    throw UnimplementedError();
  }
}
