import 'package:belcka/pages/project/project_list/controller/project_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressFilterItem extends StatelessWidget {
  final controller = Get.put(ProjectListController());
  final String title, action;
  final int? count;

  AddressFilterItem(
      {super.key, required this.title, required this.action, this.count});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Flexible(
        flex: action == 'complete' || action == 'pending' ? 3 : 2,
        child: Stack(
          children: [
            CardViewDashboardItem(
                borderColor: (controller.selectedStatusFilter.value == action)
                    ? defaultAccentColor_(context)
                    : Colors.transparent,
                boxColor: lightGreyColor(context),
                borderWidth: 2,
                elevation: 2,
                child: GestureDetector(
                  onTap: () {
                    controller.selectedStatusFilter.value = action;
                    controller.getAddressListApi(getStatus(action));
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    alignment: Alignment.center,
                    child: TitleTextView(
                      text: title,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor_(context),
                    ),
                  ),
                )),
            Visibility(
              visible: (count ?? 0) != 0,
              child: Align(
                alignment: Alignment.topRight,
                child: CustomBadgeIcon(
                  count: count ?? 0,
                  color: defaultAccentColor_(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  int getStatus(String action) {
    int status = 0;
    if (action == "all") {
      status = 0;
    } else if (action == "new") {
      status = 13;
    } else if (action == "pending") {
      status = 3;
    } else if (action == "complete") {
      status = 4;
    }
    return status;
  }
}
