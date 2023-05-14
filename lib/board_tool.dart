import 'package:flutter/material.dart';

enum ToolKind {
  pointer,
  rectangle,
  triangle,
  circle,
  line,
  oval,
  text,
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
