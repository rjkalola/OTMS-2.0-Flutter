import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';


class AdjustWidgetsScreen extends StatefulWidget {
  @override
  State<AdjustWidgetsScreen> createState() => _AdjustWidgetsScreenState();
}

class _AdjustWidgetsScreenState extends State<AdjustWidgetsScreen> {
  List<Widget> _tiles = List.generate(
    30,
        (index) => ListTile(
      key: ValueKey(index),
      title: Text('Item ${index + 1}'),
      leading: Icon(Icons.drag_handle),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scrollable Reorderable List')),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReorderableColumn(
                needsLongPressDraggable: false,
                children: _tiles,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final item = _tiles.removeAt(oldIndex);
                    _tiles.insert(newIndex, item);
                  });
                },
                buildDraggableFeedback: (context, constraints, child) {
                  return Material(
                    type: MaterialType.transparency, // No shadow
                    child: ConstrainedBox(
                      constraints: constraints,
                      child: child,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
