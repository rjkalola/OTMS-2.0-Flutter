import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step3_select_tools/controller/select_tools_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class SelectToolItemsList extends StatelessWidget {
  SelectToolItemsList({
    super.key,
  });

  // final List<ModuleInfo> itemsList;
  // final ValueChanged<int> onViewClick;
  // final int selectedIndex;
  final controller = Get.put(SelectToolsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(), //
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(
            controller.listItems.length,
            (position) => GestureDetector(
              onTap: () {
                // controller.selectedIndex.value = position;
                controller.listItems[position].check =
                    !(controller.listItems[position].check ?? false);
                controller.listItems.refresh();
              },
              child: Container(
                margin: EdgeInsets.only(top: 6, bottom: 6),
                decoration: AppUtils.getDashboardItemDecoration(
                    borderWidth: 2,
                    borderColor: (controller.listItems[position].check ?? false)
                        ? defaultAccentColor_(context)
                        : Colors.grey.shade300),
                padding: EdgeInsets.fromLTRB(16, 10, 14, 10),
                child: Row(
                  children: [
                    ImageUtils.setAssetsImage(
                        path: Drawable.timeClockImageTemp,
                        width: 30,
                        height: 30),
                    SizedBox(
                      width: 10,
                    ),
                    PrimaryTextView(
                      text: controller.listItems[position].name ?? "",
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      softWrap: true,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
