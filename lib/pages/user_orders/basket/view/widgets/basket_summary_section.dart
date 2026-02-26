import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/delivery_and_collection_buttons.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BasketSummarySection extends StatelessWidget {
  final controller = Get.put(BasketController());

@override
  Widget build(BuildContext context){
  return Obx(() => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 18, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Project
        InkWell(
          onTap: (){
            controller.showActiveProjectDialog();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrdersTitleTextView(
                text: 'Project',
                fontSize: 18,
                maxLine: 1,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OrdersTitleTextView(
                  text:!StringHelper.isEmptyString(
                      controller.activeProjectTitle.value)
                      ? controller.activeProjectTitle.value
                      : 'select_project'.tr,
                  maxLine: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                size: 25,
              ),
            ],
          ),
        ),
        // Delivery / Collection
        /*
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: DeliveryAndCollectionButtons(
                title: 'Delivery',
                isSelected: controller.isDeliverySelected.value,
                onTap: () {
                  controller.isDeliverySelected.value = true;
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: DeliveryAndCollectionButtons(
                title: 'Collection',
                isSelected: !controller.isDeliverySelected.value,
                onTap: () {
                  controller.isDeliverySelected.value = false;
                },
              ),
            ),
          ],
        ),
        */

        // Address
        const SizedBox(height: 16),
        InkWell(
          onTap: (){
            controller.showAddressList();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrdersTitleTextView(
                text: 'Address',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OrdersTitleTextView(
                  text: controller.selectedAddressTitle.value,
                  maxLine: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                size: 30,
              ),
            ],
          ),
        ),

        SizedBox(height: 16),
        // Delivery Time
        InkWell(
          onTap: (){
            controller.showDeliveryTimeList();
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            OrdersTitleTextView(text: 'Delivery Time',
                fontWeight: FontWeight.bold,
                fontSize: 18),
            SizedBox(width: 12,),
            Expanded(
              child: OrdersTitleTextView(text:controller.selectedDeliveryTime.value,
                  maxLine: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 30,
            ),
          ]),
        ),
        // Total
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          OrdersTitleTextView(text: 'Total:',
              fontSize: 18,
              fontWeight:FontWeight.bold),
          SizedBox(width: 12,),
          Expanded(
            child: OrdersTitleTextView(text:'£${controller.calculateTotal()}',
                maxLine: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
                textAlign: TextAlign.right,
                fontWeight:FontWeight.bold),
          ),
        ]),

      ]),
    ),
  ));
}
}