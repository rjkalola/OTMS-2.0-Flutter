import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/user_orders/product_set/controller/product_set_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSetItem extends StatelessWidget {
  ProductSetItem({super.key});
  final controller = Get.put(ProductSetController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageUtils.setRectangleCornerCachedNetworkImage(
              url: "https://media.istockphoto.com/id/1035076832/photo/toilet-bowl-isolated-on-white-background.jpg?s=1024x1024&w=is&k=20&c=EeubDRYHESabDlRp7vg0IU4qHwoQmY4k9C_1RTM6cwM=",
              width: 120,
              height: 120,
              borderRadius: 4,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: OrdersTitleTextView(
                      text: 'Twyford Alcona Close Coupled Toilet Pan (Horizontal Outlet) ARI148WH Twyford Alcona Close Coupled Toilet Pan (Horizontal Outlet) ARI148WH Twyford Alcona Close Coupled Toilet Pan (Horizontal Outlet) ARI148WH',
                      fontSize: 17,
                      fontWeight:FontWeight.w600 ,
                    ),
                  ),
                  Icon(Icons.bookmark_outlined, size: 30,color: Colors.deepOrangeAccent,),
                ],
              ),
              const SizedBox(height: 12),
              OrdersTitleTextView(
                  text: '£4378779.21',
                  fontSize: 18,
                  maxLine: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold
              ),
              Row(
                children: [
                  Expanded(
                    child: OrdersTitleTextView(
                      text: 'DCK: EB0218 EB0218 EB0218 EB0218',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  OrderQuantityChangeButton(
                      text: "-", onTap: (){}),
                  SizedBox(width: 8),
                  OrderQuantityDisplayTextView(value: 1),
                  SizedBox(width: 8),
                  OrderQuantityChangeButton(
                      text: "+", onTap: (){}),
                  const Spacer(),
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.green,
                    size: 30,
                  ),
                ],
              ),
              SizedBox(height: 12,),
              OrdersTitleTextView(
                text: 'Qty: 100000',
                fontSize: 15,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLine: 2,
              )
            ],
          ),
        ),
      ],
    );
  }
}