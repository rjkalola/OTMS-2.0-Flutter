import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/pages/project/address_details/view/widgets/address_details_filter_item.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressDetailsFilterList extends StatelessWidget {
  AddressDetailsFilterList({super.key});

  final controller = Get.put(AddressDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AddressDetailsFilterItem(
                title: 'check_in_'.tr,
                action: AppConstants.action.checkIn,
                count: controller.checkInsCount.value,
              ),
              SizedBox(
                width: 6,
              ),
              AddressDetailsFilterItem(
                  title: 'trades'.tr,
                  action: AppConstants.action.trades,
                  count: controller.tradesCount.value),
            ],
          ),
        ));
  }
}

// class _AddressFilterListState extends State<AddressFilterList> {
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Padding(
//       padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           AddressFilterItem(
//             title: 'all'.tr,
//             action: "all",
//             count: controller.allCount.value,
//           ),
//           SizedBox(
//             width: 6,
//           ),
//           AddressFilterItem(title: 'new'.tr, action: "new"),
//           SizedBox(
//             width: 6,
//           ),
//           AddressFilterItem(title: 'pending'.tr, action: "pending"),
//           SizedBox(
//             width: 6,
//           ),
//           AddressFilterItem(title: 'complete'.tr, action: "complete")
//         ],
//       ),
//     ),);
//   }
// }
