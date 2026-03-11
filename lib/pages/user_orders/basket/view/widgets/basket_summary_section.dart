import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/delivery_and_collection_buttons.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
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
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
            controller.showActiveProjectDialog();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextView(
                text: 'project'.tr,
                fontSize: 16,
                maxLine: 1,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TitleTextView(
                  text:!StringHelper.isEmptyString(
                      controller.activeProjectTitle.value)
                      ? controller.activeProjectTitle.value
                      : 'select_project'.tr,
                  maxLine: 1,
                  softWrap: true,
                  textAlign: TextAlign.right,
                  fontSize: 15,
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
        // Store Section
        const SizedBox(height: 16),
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
            controller.showStoresList();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextView(
                text: 'store'.tr,
                fontSize: 16,
                maxLine: 1,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TitleTextView(
                  text:!StringHelper.isEmptyString(
                      controller.selectedStoreTitle.value)
                      ? controller.selectedStoreTitle.value
                      : 'select_store'.tr,
                  maxLine: 1,
                  softWrap: true,
                  textAlign: TextAlign.right,
                  fontSize: 15,
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
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
            controller.showAddressList();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextView(
                text: 'address'.tr,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OrdersTitleTextView(
                  text: controller.selectedAddressTitle.value,
                  maxLine: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor_(context),
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
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
            controller.showDeliveryTimeList();
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TitleTextView(
                text: 'delivery_time'.tr,
                fontWeight: FontWeight.w700,
                fontSize: 16),
            SizedBox(width: 12,),
            Expanded(
              child: TitleTextView(text:controller.selectedDeliveryTime.value,
                  maxLine: 1,
                  softWrap: true,
                  textAlign: TextAlign.right,
                  fontSize: 15,
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
          TitleTextView(
              text: "${'total'.tr}:",
              fontSize: 16,
              fontWeight:FontWeight.w700),
          SizedBox(width: 12,),
          Expanded(
            child: TitleTextView(text:'£${controller.calculateTotal()}',
                maxLine: 1,
                softWrap: true,
                fontSize: 16,
                textAlign: TextAlign.right,
                fontWeight:FontWeight.w700),
          ),
        ]),

      ]),
    ),
  ));
}
}