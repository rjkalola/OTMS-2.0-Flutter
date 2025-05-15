import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/view/widgets/dashboard_grid_item_view.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/gridview/VariableHeightGrid.dart';

class DashboardGridView extends StatelessWidget {
  DashboardGridView({super.key});

  final controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: VariableHeightGrid(
          items: List.generate(controller.listGridItems.length, (index) {
            return DashboardGridItemView(
              info: controller.listGridItems[index],
            );
          }),
        ),

       /* child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // Prevents nested scrolling issues
          itemCount: controller.listGridItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            // childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            return DashboardGridItemView(
              info: controller.listGridItems[index],
            );
          },
        )*/


      /*   child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.listGridItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // controller.selectedIndex.value = index;
                    // onViewClick(index);
                  },
                  child: DashboardGridItemView(
                    info: controller.listGridItems[index],
                  ),
                );
              }),*/
    );
  }
}
