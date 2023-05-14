import 'package:flutter/material.dart';
import 'package:simple_board/board_tool.dart';

void main() {
  runApp(const BoardApp());
}

class BoardApp extends StatelessWidget {
  const BoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const BoardHomePage(),
    );
  }
}

class BoardHomePage extends StatefulWidget {
  const BoardHomePage({super.key});

  @override
  State<BoardHomePage> createState() => _BoardHomePageState();
}

class _BoardHomePageState extends State<BoardHomePage> {
  int curSelected = 0;
  final toolList = <BoardItem>[
    PointerItem(),
    RectItem(),
    OvalItem(),
    TriangleItem(),
    CircleItem(),
    LineItem(),
    TextItem()
  ];

  @override
  Widget build(BuildContext context) {
    if (curSelected >= toolList.length) {
      throw UnimplementedError('No operation defined for index $curSelected');
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Simple Board',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16.0),
            Icon(
              Icons.color_lens,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
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

      body: Row(
        children: [
          NavigationRail(
            extended: false,
            destinations: [
              for (var item in toolList)
                NavigationRailDestination(
                  icon: Icon(item.iconData),
                  label: Text(item.toolName),
                ),
            ],
            selectedIndex: curSelected,
            onDestinationSelected: (value) {
              setState(() {
                curSelected = value;
              });
            },
          ),
          const Expanded(
            child: Placeholder(),
          ),
        ],
      ),
    );
  }
}
