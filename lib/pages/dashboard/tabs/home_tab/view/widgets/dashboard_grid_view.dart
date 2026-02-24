import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/reorder_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/view/widgets/dashboard_grid_item.dart';

import '../../../../../../utils/app_storage.dart';

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

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              print("controller.isApiLoading:"+controller.isApiLoading.toString());
              if(!controller.isApiLoading){
                if (Get.find<AppStorage>().isLocalSequenceChanges()) {
                  await controller
                      .changeDashboardUserPermissionMultipleSequenceApi(
                      isProgress: false,
                      isLoadPermissionList: true,
                      isChangeSequence: false);
                } else {
                  await controller.getDashboardUserPermissionsApi(false,
                      isProfileLoad: true);
                }
              }
            },
            child: ReorderableBuilder(
              scrollController: _scrollController,
              onReorderPositions: (positions) {
                print("onReorderPositions");
                controller.isOnDrag.value = false;
                final info = positions.first;
                controller.onReorderPermission(info.oldIndex, info.newIndex);
              },
              onDragStarted: (positions) {
                controller.isOnDrag.value = true;
                print("onDragStarted");
              },
              onDragEnd: (positions) {
                controller.isOnDrag.value = false;
                print("onDragEnd");
              },
              dragChildBoxDecoration:
                  const BoxDecoration(color: Colors.transparent),
              builder: (children) {
                return GridView(
                  key: _gridViewKey,
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  children: children,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 100,
                  ),
                );
              },
              children: List.generate(
                controller.listPermissions.length,
                (index) => DashboardGridItem(
                  key: Key(controller.listPermissions[index].permissionId
                          ?.toString() ??
                      ''),
                  info: controller.listPermissions[index],
                  index: index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
