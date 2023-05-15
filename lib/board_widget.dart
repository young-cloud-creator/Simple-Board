import 'package:flutter/material.dart';
import 'package:simple_board/board_tool.dart';

class BoardBgPainter extends CustomPainter {
  final backgroundPaint = Paint();
  @override
  void paint(Canvas canvas, Size size) {
    backgroundPaint.color = Colors.white;
    canvas.drawRect(
      Rect.fromPoints(const Offset(0, 0), size.bottomRight(const Offset(0, 0))),
      backgroundPaint,
    );
  }

  @override
  bool shouldRepaint(BoardBgPainter oldDelegate) {
    return true;
  }
}

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final points = <Offset?>[];
  final bgPainter = BoardBgPainter();

  _BoardState() {
    BoardManager.instance.addListener(updatePoints);
  }

  void updatePoints() {
    if (BoardManager.instance.needClear) {
      BoardManager.instance.needClear = false;
      setState(() {
        points.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onPanStart: (details) {
            points.add(details.localPosition);
          },
          onPanUpdate: (details) {
            final xPos = details.localPosition.dx>=0 ? details.localPosition.dx : 0.0;
            final yPos = details.localPosition.dy>=0 ? details.localPosition.dy : 0.0;
            setState(() {
              points.add(Offset(xPos, yPos));
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add(null);
            });
          },
          child: CustomPaint(
            painter: bgPainter,
            foregroundPainter: BoardFgPainter(points: points),
          ),
        ),
      ],
    );
  }
}

class BoardFgPainter extends CustomPainter {
  BoardFgPainter({required this.points});

  final List<Offset?> points;
  final foregroundPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    foregroundPaint.color = Colors.black;
    foregroundPaint.strokeWidth = 3.0;
    for (int i = 0; i < points.length - 1; ++i) {
      if (points[i] == null || points[i + 1] == null) {
        continue;
      }
      canvas.drawLine(points[i]!, points[i + 1]!, foregroundPaint);
    }
  }

  @override
  bool shouldRepaint(BoardFgPainter oldDelegate) {
    return true;
  }
}
