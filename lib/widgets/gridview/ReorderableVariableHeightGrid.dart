import 'package:flutter/material.dart';
import 'package:otm_inventory/widgets/gridview/VariableHeightGrid.dart';

class ReorderableVariableHeightGridPage extends StatefulWidget {
  @override
  _ReorderableVariableHeightGridPageState createState() =>
      _ReorderableVariableHeightGridPageState();
}

class _ReorderableVariableHeightGridPageState
    extends State<ReorderableVariableHeightGridPage> {
  List<int> items = List.generate(9, (i) => i);

  void _reorder(int from, int to) {
    setState(() {
      final item = items.removeAt(from);
      items.insert(to, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reorderable VariableHeightGrid')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: VariableHeightGrid(
          items: List.generate(
            items.length,
            (index) => _buildDraggableItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableItem(int index) {
    final value = items[index];
    final color = Colors.primaries[value % Colors.primaries.length];
    // final height = 100.0 + (value % 3) * 40.0;

    return Draggable<int>(
      data: index,
      feedback: SizedBox(
        width: MediaQuery.of(context).size.width / 2 -
            20, // match Expanded tile width
        // height: height,
        child: Material(
          color: Colors.transparent,
          child: _buildTile(value, 0, color, dragging: true),
        ),
      ),
      childWhenDragging:
          Opacity(opacity: 0.2, child: _buildTile(value, 0, color)),
      child: DragTarget<int>(
        onWillAcceptWithDetails: (from) => from != index,
        onAcceptWithDetails: (from) => _reorder(from.data, index),
        builder: (context, candidateData, rejectedData) {
          return _buildTile(value, 0, color);
        },
      ),
    );
  }

  Widget _buildTile(int value, double height, Color color,
      {bool dragging = false}) {
    return Container(
      // height: height,
      decoration: BoxDecoration(
        color: dragging ? color.withOpacity(0.6) : color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Item $value',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
