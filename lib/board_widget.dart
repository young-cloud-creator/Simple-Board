import 'package:flutter/material.dart';
import 'package:simple_board/board_component.dart';
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
    return false;
  }
}

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();

  List<ShapeComponent> getShapes() {
    return _BoardState.instance!.components;
  }

  List<ShapeComponent> cloneShapes() {
    return _BoardState.instance!.getClonedShapes();
  }

  void addShape(ShapeComponent component) {
    _BoardState.instance!.addShape(component);
  }

  void addShapes(List<ShapeComponent> componentList) {
    _BoardState.instance!.addShapes(componentList);
  }
}

class _BoardState extends State<Board> {
  final components = <ShapeComponent>[];
  final bgPainter = BoardBgPainter();
  static _BoardState? instance;

  _BoardState() {
    instance = this;
    BoardManager.instance.addListener(boardCommandListener);
  }

  void boardCommandListener() {
    if (BoardManager.instance.undoLast) {
      BoardManager.instance.undoLast = false;
      List<ShapeComponent>? lastState = BoardManager.instance.lastState;
      if (lastState != null) {
        BoardManager.instance.lastState = getClonedShapes();
        setState(() {
          components.clear();
          components.addAll(lastState);
        });
      }
    }
    if (BoardManager.instance.needClear) {
      BoardManager.instance.needClear = false;
      if (components.isNotEmpty) {
        BoardManager.instance.lastState = getClonedShapes();
        setState(() {
          components.clear();
        });
      }
    }
    if (BoardManager.instance.needShowTextDialog) {
      BoardManager.instance.needShowTextDialog = false;
      showDialog(
        context: context,
        builder: (context) {
          final textController = TextEditingController();
          textController.text = BoardManager.instance.curText;
          final textField = TextField(controller: textController);
          return AlertDialog(
            title: const Text("输入要插入的文本"),
            content: textField,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  BoardManager.instance.curText = textController.value.text;
                  Navigator.pop(context);
                },
                child: const Text("确定"),
              ),
            ],
          );
        },
      );
    }
  }

  List<ShapeComponent> getClonedShapes() {
    var backupList = <ShapeComponent>[];
    for (var shape in components) {
      backupList.add(shape.deepCopy());
    }
    return backupList;
  }

  void addShape(ShapeComponent component) {
    setState(() {
      components.add(component);
    });
  }

  void addShapes(List<ShapeComponent> componentList) {
    setState(() {
      components.addAll(componentList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              BoardManager.instance.onPanStart(details.localPosition);
            });
          },
          onPanUpdate: (details) {
            final xPos =
                details.localPosition.dx >= 0 ? details.localPosition.dx : 0.0;
            final yPos =
                details.localPosition.dy >= 0 ? details.localPosition.dy : 0.0;
            setState(() {
              BoardManager.instance.onPanUpdate(Offset(xPos, yPos));
            });
          },
          onPanEnd: (details) {
            setState(() {
              BoardManager.instance.onPanEnd();
            });
          },
          child: CustomPaint(
            painter: bgPainter,
            foregroundPainter: BoardFgPainter(components: components),
          ),
        ),
      ],
    );
  }
}

class BoardFgPainter extends CustomPainter {
  BoardFgPainter({required this.components}) {
    foregroundPaint.style = PaintingStyle.stroke;
    foregroundPaint.strokeWidth = 3;
    foregroundPaint.isAntiAlias = true;
  }

  final List<ShapeComponent> components;
  final foregroundPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (Pointer.instance.exists()) {
      Pointer.instance.draw(canvas, size);
      var rangePoints = Pointer.instance.getPoints();
      for (var shape in components) {
        if (shape.isInRect(rangePoints.$1, rangePoints.$2)) {
          shape.isSelected = true;
        } else {
          shape.isSelected = false;
        }
      }
    }
    for (var shape in components) {
      shape.draw(canvas, size, foregroundPaint);
      if (shape.isSelected) {
        shape.drawBoundingBox(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(BoardFgPainter oldDelegate) {
    return true;
  }
}
