import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressDetailsFilterItem extends StatelessWidget {
  final controller = Get.put(AddressDetailsController());

  final String title, action;
  final int? count;

  AddressDetailsFilterItem(
      {super.key, required this.title, required this.action, this.count});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Stack(
          children: [
            CardViewDashboardItem(
                borderColor: (controller.selectedFilter.value == action)
                    ? defaultAccentColor_(context)
                    : Colors.transparent,
                boxColor: lightGreyColor(context),
                borderWidth: 2,
                elevation: 2,
                child: GestureDetector(
                  onTap: () {
                    controller.selectedFilter.value = action;
                    controller.getAddressDetailsApi();
                    // controller.onSelectAddressFilter(action, true);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
}
