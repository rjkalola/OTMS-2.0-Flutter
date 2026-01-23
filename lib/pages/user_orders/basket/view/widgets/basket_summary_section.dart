import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/delivery_and_collection_buttons.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BasketSummarySection extends StatelessWidget {
  final controller = Get.put(BasketController());

Widget build(BuildContext context){
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Project
        Row(
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
                text:'Haringey Voids Haringey Voids Haringey Voids',
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
        SizedBox(height: 18),
        // Delivery / Collection
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
        const SizedBox(height: 22),
        // Address
        Row(
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
                text: '600 High Road, Tottenham, London, United Kingdom',
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
        SizedBox(height: 14),
        // Delivery Time
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          OrdersTitleTextView(text: 'Delivery Time',
              fontWeight: FontWeight.bold,
              fontSize: 18),
          SizedBox(width: 12,),
          Expanded(
            child: OrdersTitleTextView(text: 'Any Time Any Time Any Time Any Time',
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
        const SizedBox(height: 18),
        // Total
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          OrdersTitleTextView(text: 'Total:',
              fontSize: 18,
              fontWeight:FontWeight.bold),
          SizedBox(width: 12,),
          Expanded(
            child: OrdersTitleTextView(text: '£3243324332433243.21',
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
  );
}
}