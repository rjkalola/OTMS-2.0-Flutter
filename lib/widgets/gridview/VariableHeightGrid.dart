import 'package:flutter/material.dart';

/*class VariableHeightGrid extends StatelessWidget {
  final List<Widget> items;

  const VariableHeightGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : SizedBox();

      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: left),
              SizedBox(width: 8),
              Expanded(child: right),
            ],
          ),
        ),
      );

      rows.add(SizedBox(height: 8)); // spacing between rows
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}*/

class VariableHeightGrid extends StatelessWidget {
  final List<Widget> items;

  const VariableHeightGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : const SizedBox();

      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: left),
              SizedBox(width: 8),
              Expanded(child: right),
            ],
          ),
        ),
      );

      if (i + 2 < items.length) {
        rows.add(SizedBox(height: 8));
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}

