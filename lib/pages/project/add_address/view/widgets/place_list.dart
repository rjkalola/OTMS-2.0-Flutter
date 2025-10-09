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
        visible: controller.searchResults.isNotEmpty,
        child: CardViewDashboardItem(
          margin: EdgeInsets.fromLTRB(12, 80, 12, 5),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final place = controller.searchResults[index];
              return ListTile(
                title: Text(place['description']),
                onTap: () {
                  controller.selectPlace(place['place_id']);
                  controller.siteAddressController.value.text =
                      place['description'];
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
