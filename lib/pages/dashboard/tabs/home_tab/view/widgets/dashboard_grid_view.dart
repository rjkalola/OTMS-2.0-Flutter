import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/reorder_update_entity.dart';
import 'package:flutter_reorderable_grid_view/entities/reorderable_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/dashboard_grid_item_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/view/widgets/dashboard_grid_item.dart';

class DashboardGridView extends StatelessWidget {
  DashboardGridView({super.key});

  final controller = Get.put(HomeTabController());
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  // final listDragItems = <DraggableGridItem>[].obs;

  @override
  Widget build(BuildContext context) {
    /* listDragItems.value = List.generate(
      controller.listPermissions.length,
      (index) => DraggableGridItem(
        isDraggable: true,
        child: DashboardGridItem(
          info: controller.listPermissions[index],
        ),
      ),
    );
    listDragItems.refresh();*/

    return Obx(
      () => Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ReorderableBuilder(
            scrollController: _scrollController,
            onReorderPositions: (_) {
              List<ReorderUpdateEntity> list = _;
              ReorderUpdateEntity info = list.first;
              controller.onReorderPermission(info.oldIndex, info.newIndex);
            },
            // onReorder: (ReorderedListFunction reorderedListFunction) {
            //   controller.listPermissions.value =
            //       reorderedListFunction(controller.listPermissions)
            //           as List<PermissionInfo>;
            //   // setState(() {
            //   //   _fruits = reorderedListFunction(_fruits) as List<String>;
            //   // });
            // },
            dragChildBoxDecoration: BoxDecoration(color: Colors.transparent),
            builder: (children) {
              return GridView(
                key: _gridViewKey,
                controller: _scrollController,
                children: children,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 90, // FIXED height of each tile
                ),
              );
            },
            children: List.generate(
              controller.listPermissions.length,
              (index) => DashboardGridItem(
                key: Key(controller.listPermissions[index].permissionId!
                        .toString() ??
                    ""),
                info: controller.listPermissions[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
