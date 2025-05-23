import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/controller/team_users_count_info_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/gridview/VariableHeightGrid.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TeamUsersCountItemsList extends StatelessWidget {
  TeamUsersCountItemsList(
      {super.key,
      required this.itemsList,
      required this.onViewClick,
      required this.selectedIndex});

  final List<ModuleInfo> itemsList;
  final ValueChanged<int> onViewClick;
  final int selectedIndex;

  final controller = Get.put(TeamUsersCountInfoController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        // child: MasonryGridView.count(
        //     crossAxisCount: 3,
        //     mainAxisSpacing: 16,
        //     crossAxisSpacing: 12,
        //     shrinkWrap: true,
        //     physics: NeverScrollableScrollPhysics(),
        //     itemCount: controller.listItems.length,
        //     itemBuilder: (context, index) {
        //       return GestureDetector(
        //         onTap: () {
        //           controller.selectedIndex.value = index;
        //           // onViewClick(index);
        //         },
        //         child: Container(
        //           decoration: AppUtils.getDashboardItemDecoration(
        //               borderWidth: 2,
        //               borderColor: (selectedIndex == index)
        //                   ? defaultAccentColor
        //                   : Colors.grey.shade300),
        //           padding: EdgeInsets.all(12),
        //           child: Center(
        //             child: PrimaryTextView(
        //               text: itemsList[index].name ?? "",
        //               fontWeight: FontWeight.bold,
        //               textAlign: TextAlign.center,
        //               fontSize: 16,
        //               softWrap: true,
        //             ),
        //           ),
        //         ),
        //       );
        //     }),

        child: VariableHeightGrid(
          items: List.generate(controller.listItems.length, (index) {
            return GestureDetector(
              onTap: () {
                controller.selectedIndex.value = index;
                // onViewClick(index);
              },
              child: Container(
                decoration: AppUtils.getDashboardItemDecoration(
                    borderWidth: 2,
                    borderColor: (selectedIndex == index)
                        ? defaultAccentColor
                        : Colors.grey.shade300),
                padding: EdgeInsets.all(12),
                child: Center(
                  child: PrimaryTextView(
                    text: itemsList[index].name ?? "",
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    softWrap: true,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
