import 'package:flutter/material.dart';
import 'package:simple_board/board_tool.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

final boardBarState = BoardBarState();

void main() {
  runApp(const BoardApp());
}

class BoardApp extends StatelessWidget {
  const BoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return ChangeNotifierProvider(
      create: (context) => boardBarState,
      child: MaterialApp(
        title: 'Simple Board',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const BoardHomePage(),
      ),
    );
  }
}

class BoardBarState extends ChangeNotifier {
  int curSelected = 0;
  final toolList = <BoardItem>[
    PointerItem(),
    PencilItem(),
    RectItem(),
    OvalItem(),
    TriangleItem(),
    CircleItem(),
    LineItem(),
    TextItem(),
  ];

  void changeCurSelected(int value) {
    curSelected = value;
    if (value < 0 || value >= toolList.length) {
      throw UnimplementedError('No operation defined for index $curSelected');
    }
    notifyListeners();
  }
}

class BoardHomePage extends StatelessWidget {
  const BoardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardBarState>();
    final curSelected = boardState.curSelected;
    final toolList = boardState.toolList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              'Simple Board',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10.0),
            Icon(
              Icons.color_lens,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              BoardManager.instance.clearBoard();
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
          ),
          IconButton(
            onPressed: () {
              BoardManager.instance.tryUndo();
            },
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.copy),
            tooltip: 'Copy',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.paste),
            tooltip: 'Paste',
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            NavigationRail(
              backgroundColor: Colors.white,
              extended: constraints.maxWidth >= 850,
              destinations: [
                for (var item in toolList)
                  NavigationRailDestination(
                    icon: Icon(item.iconData),
                    label: Text(item.toolName),
                  ),
              ],
              selectedIndex: curSelected,
              onDestinationSelected: (value) {
                boardState.changeCurSelected(value);
              },
            ),
            Expanded(
              child: BoardManager.instance.curBoard,
            ),
          ],
        );
      }),
    );
  }
}
