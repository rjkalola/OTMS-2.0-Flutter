import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:otm_inventory/pages/project/address_details/controller/address_details_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class AddressDetailsGridItems extends StatelessWidget {
  final controller = Get.put(AddressDetailsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        //
        itemCount: controller.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2
                  : 3,
          // more columns in landscape
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 90,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (controller.items[index].title == "Check-In") {
                var arguments = {
                  AppConstants.intentKey.projectId:
                      controller.addressInfo?.projectId ?? 0,
                  AppConstants.intentKey.addressId:
                      controller.addressInfo?.id ?? 0,
                };
                controller.moveToScreen(
                    AppRoutes.checkInRecordsScreen, arguments);
              } else if (controller.items[index].title == "Trades") {
                var arguments = {
                  AppConstants.intentKey.projectId:
                      controller.addressInfo?.projectId ?? 0,
                  AppConstants.intentKey.addressId:
                      controller.addressInfo?.id ?? 0,
                };
                controller.moveToScreen(
                    AppRoutes.tradeRecordsScreen, arguments);
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Your main card
                CardViewDashboardItem(
                  padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageUtils.setSvgAssetsImage(
                          path: controller.items[index].iconPath ?? "",
                          color: AppUtils.getColor(
                              controller.items[index].iconColor ?? ""),
                          width: 30,
                          height: 30),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.items[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            if (controller.items[index].subtitle.isNotEmpty)
                              Text(
                                controller.items[index].subtitle,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
