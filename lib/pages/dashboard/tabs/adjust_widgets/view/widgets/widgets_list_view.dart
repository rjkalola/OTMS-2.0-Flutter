import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/adjust_widgets/view/widgets/widgets_list_item.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';

import 'package:reorderables/reorderables.dart';

class WidgetsListView extends StatelessWidget {
  WidgetsListView({super.key});

  final controller = Get.put(HomeTabController());
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  final _tiles = <Widget>[].obs;

  @override
  Widget build(BuildContext context) {
    _tiles.value = List.generate(
      controller.listPermissions.length,
      (index) => _buildTile(index),
    );

    return Obx(
      () => ReorderableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          needsLongPressDraggable: false,
          // drag on touch
          children: _tiles,
          onReorder: (oldIndex, newIndex) {
            print("oldIndex:"+oldIndex.toString());
            print("newIndex:"+newIndex.toString());
            final item = _tiles.removeAt(oldIndex);
            _tiles.insert(newIndex, item);
          },
          buildDraggableFeedback: (context, constraints, child) {
            return Material(
              type: MaterialType.transparency,
              // Removes default shadow
              child: ConstrainedBox(
                constraints: constraints,
                // Required to avoid drag issues
                child: child,
              ),
            );
          }),
    );
  }

  Widget _buildTile(int index) {
    return WidgetsListItem(
      key:
          Key(controller.listPermissions[index].permissionId!.toString() ?? ""),
      info: controller.listPermissions[index],
      index: index,
    );
  }
}
