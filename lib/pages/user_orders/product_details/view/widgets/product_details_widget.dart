import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:belcka/pages/user_orders/product_details/controller/product_details_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget({super.key});

  final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      ImageUtils.setRectangleCornerCachedNetworkImage(
                        url: "https://media.istockphoto.com/id/1035076832/photo/toilet-bowl-isolated-on-white-background.jpg?s=1024x1024&w=is&k=20&c=EeubDRYHESabDlRp7vg0IU4qHwoQmY4k9C_1RTM6cwM=",
                        width: 120,
                        height: 150,
                        borderRadius: 4,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.orange.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Product Details
            OrdersTitleTextView(
              text:'Twyford Alcona Close Coupled Toilet Pan '
                  '(Horizontal Outlet) AR1148WH Twyford Alcona Close Coupled Toilet Pan '
                  '(Horizontal Outlet) AR1148WH Twyford Alcona Close Coupled Toilet Pan '
                  '(Horizontal Outlet) AR1148WH',
                fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8),
            OrdersTitleTextView(text: 'DCK: EB0214'),
            OrdersTitleTextView(text: 'Product code: 885400'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrdersTitleTextView(
                      text: '£43.21',
                      fontWeight:FontWeight.bold ,
                      fontSize: 20,
                    ),
                    SizedBox(height: 4),
                    OrdersTitleTextView(text: 'Available QTY: 5'),
                  ],
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.green,
                        size: 30,
                      ),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OrderQuantityChangeButton(
                              text: "-", onTap: (){}),
                          SizedBox(width: 8),
                          OrderQuantityDisplayTextView(value: 1),
                          SizedBox(width: 8),
                          OrderQuantityChangeButton(
                              text: "+", onTap: (){}),
                        ],
                      ),
                      SizedBox(height: 8,),
                      OrdersTitleTextView(
                       text:'Qty: 1',
                          fontSize: 15
                      ),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 20),
            NavigationCard(value: "Product Set".tr,isShowArrow: true,),
            NavigationCard(value: "Product Information".tr,isShowArrow: true,),
            NavigationCard(value: "Technical Specification".tr,isShowArrow: true,),
          ],
        ),
      ),
    );
  }
}