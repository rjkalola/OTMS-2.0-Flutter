import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/check_in/select_address/controller/select_address_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:get/get.dart';

class AddressListWidget extends StatelessWidget {
  AddressListWidget({super.key});

  final controller = Get.put(SelectAddressController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        //
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, position) => Divider(
          color: dividerColor,
        ),
        itemBuilder: (context, position) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: primaryTextColor,
                      softWrap: true,
                      text: controller.addressList[position].name ?? "",
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  CircleWidget(
                      color: getStatusColor(
                          controller.addressList[position].filterValue ?? 0),
                      width: 13,
                      height: 13)
                ],
              ),
            ),
          );
        },
        itemCount: controller.addressList.length,
      ),
    );
  }

  Color getStatusColor(int filterValue) {
    Color color = Color(AppUtils.haxColor("#FF6464"));
    if (filterValue == 1) {
      color = Color(AppUtils.haxColor("#FFDC4A"));
    } else if (filterValue == 2) {
      color = Color(AppUtils.haxColor("#FF6464"));
    } else if (filterValue == 3) {
      color = Color(AppUtils.haxColor("#2DC75C"));
    }
    return color;
  }
}
