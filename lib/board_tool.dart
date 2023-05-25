import 'package:flutter/material.dart';
import 'package:simple_board/board_component.dart';
import 'package:simple_board/board_widget.dart';
import 'package:simple_board/main.dart';

enum ToolKind {
  pointer,
  rectangle,
  triangle,
  circle,
  line,
  oval,
  text,
  pencil,
}

class BoardManager extends ChangeNotifier {
  var curTool = boardBarState.toolList[boardBarState.curSelected].toolKind;
  List<ShapeComponent>? lastState;
  Board curBoard = const Board();
  BoardManager._constructor() {
    boardBarState.addListener(() {
      curTool = boardBarState.toolList[boardBarState.curSelected].toolKind;
      if (curTool == ToolKind.text) {
        // TODO: Show a dialog to get text
      }
    });
  }

  static final BoardManager _managerInstance = BoardManager._constructor();
  static BoardManager get instance {
    return _managerInstance;
  }

  var needClear = false;
  void clearBoard() {
    needClear = true;
    notifyListeners();
  }

  var undoLast = false;
  void tryUndo() {
    undoLast = true;
    notifyListeners();
  }

  ShapeComponent? curComponent;
  void onPanStart(Offset pos) {
    ShapeComponent? newComponent;
    switch (curTool) {
      case ToolKind.pointer:
        break;
      case ToolKind.rectangle:
        newComponent = RectComponent();
        break;
      case ToolKind.triangle:
        newComponent = TriangleComponent();
        break;
      case ToolKind.circle:
        newComponent = CircleComponent();
        break;
      case ToolKind.line:
        newComponent = LineComponent();
        break;
      case ToolKind.oval:
        newComponent = OvalComponent();
        break;
      case ToolKind.text:
        newComponent = TextComponent();
        break;
      case ToolKind.pencil:
        newComponent = PencilComponent();
        break;
    }

    if (newComponent != null) {
      newComponent.startBuild(pos);
      curBoard.addShape(newComponent);
      curComponent = newComponent;
    }
  }

  void onPanUpdate(Offset pos) {
    curComponent?.updateDst(pos);
  }

  void onPanEnd() {
    if (curComponent != null) {
      lastState = curBoard.cloneShapes();
      lastState?.removeLast();
      curComponent = null;
    }
  }
}

abstract class BoardItem {
  BoardItem(this.iconData, this.toolName, this.toolKind);

  IconData iconData;
  String toolName;
  ToolKind toolKind;
}

class PointerItem extends BoardItem {
  PointerItem()
      : super(
          const IconData(0xea0e, fontFamily: 'sidebarIcon'),
          'Pointer',
          ToolKind.pointer,
        );
}

class RectItem extends BoardItem {
  RectItem()
      : super(
          const IconData(0xeb97, fontFamily: 'sidebarIcon'),
          'Rectangle',
          ToolKind.rectangle,
        );
}

class TriangleItem extends BoardItem {
  TriangleItem()
      : super(
          const IconData(0xe652, fontFamily: 'sidebarIcon'),
          'Triangle',
          ToolKind.triangle,
        );
}

class CircleItem extends BoardItem {
  CircleItem()
      : super(
          const IconData(0xea6a, fontFamily: 'sidebarIcon'),
          'Circle',
          ToolKind.circle,
        );
}

class LineItem extends BoardItem {
  LineItem()
      : super(
          const IconData(0xe636, fontFamily: 'sidebarIcon'),
          'Line',
          ToolKind.line,
        );
}

class OvalItem extends BoardItem {
  OvalItem()
      : super(
          const IconData(0xe790, fontFamily: 'sidebarIcon'),
          'Oval',
          ToolKind.oval,
        );
}

class TextItem extends BoardItem {
  TextItem()
      : super(
          const IconData(0xe680, fontFamily: 'sidebarIcon'),
          'Text',
          ToolKind.text,
        );
}

class PencilItem extends BoardItem {
  PencilItem()
      : super(
          Icons.edit_outlined,
          'Pencil',
          ToolKind.pencil,
        );
}
