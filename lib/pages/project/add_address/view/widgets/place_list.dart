import 'package:belcka/pages/project/add_address/controller/add_address_controller.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceList extends StatelessWidget {
  PlaceList({super.key});

  final controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.addressList.isNotEmpty,
        child: CardViewDashboardItem(
          margin: EdgeInsets.fromLTRB(12, 140, 12, 5),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.addressList.length,
            itemBuilder: (context, index) {
              final place = controller.addressList[index];
              return ListTile(
                title: Text(place.summaryline ?? ""),
                onTap: () {
                  controller.selectPlace(place.postcode ?? "");
                  controller.siteAddressController.value.text =
                      place.summaryline ?? "";
                  controller.isSaveEnable.value =
                      controller.siteAddressController.value.text.trim().isNotEmpty;
                 controller.clearSearch();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
