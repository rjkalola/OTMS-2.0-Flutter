import 'package:belcka/pages/project/project_list/controller/project_list_controller.dart';
import 'package:belcka/pages/project/project_list/view/widgets/address_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressFilterList extends StatelessWidget {
  AddressFilterList({super.key});

  final controller = Get.put(ProjectListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AddressFilterItem(
                title: 'all'.tr,
                action: "all",
                count: controller.allCount.value,
              ),
              SizedBox(
                width: 6,
              ),
              AddressFilterItem(
                  title: 'new'.tr,
                  action: "new",
                  count: controller.newCount.value),
              SizedBox(
                width: 6,
              ),
              AddressFilterItem(
                  title: 'pending'.tr,
                  action: "pending",
                  count: controller.pendingCount.value),
              SizedBox(
                width: 6,
              ),
              AddressFilterItem(
                  title: 'complete'.tr,
                  action: "complete",
                  count: controller.completeCount.value)
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
