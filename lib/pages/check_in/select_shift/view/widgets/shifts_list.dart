import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/select_shift/controller/select_shift_controller.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class ShiftsList extends StatelessWidget {
  ShiftsList({super.key});

  final controller = Get.put(SelectShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                ModuleInfo info = controller.shiftList[position];
                return CardViewDashboardItem(
                    elevation: 1,
                    shadowColor: Colors.black45,
                    borderRadius: 12,
                    margin: EdgeInsets.fromLTRB(14, 6, 14, 6),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: InkWell(
                        onTap: () {
                         controller.userStartWorkApi(info.id??0);
                        },
                        child: Row(
                          children: [
                            CircleWidget(
                                color: getRandomColor(), width: 20, height: 20),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: TitleTextView(
                                text: info.name ?? "",
                                fontSize: 17,
                              ),
                            ),
                            RightArrowWidget()
                          ],
                        ),
                      ),
                    ));
              },
              itemCount: controller.shiftList.length,
              separatorBuilder: (context, position) => Container()),
        ));
  }

  Color getRandomColor() {
    String color = "#CB4646DD";
    final random = Random();
    int randomNumber = random.nextInt(DataUtils.listColors.length - 1);
    color = DataUtils.listColors[randomNumber];
    return Color(AppUtils.haxColor(color));
  }
}
