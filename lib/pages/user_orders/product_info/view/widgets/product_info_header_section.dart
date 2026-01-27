import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInfoHeaderSection extends StatelessWidget {
  ProductInfoHeaderSection({super.key});

  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageUtils.setRectangleCornerCachedNetworkImage(
          url: "https://media.istockphoto.com/id/1035076832/photo/toilet-bowl-isolated-on-white-background.jpg?s=1024x1024&w=is&k=20&c=EeubDRYHESabDlRp7vg0IU4qHwoQmY4k9C_1RTM6cwM=",
          width: 120,
          height: 120,
          borderRadius: 4,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: OrdersTitleTextView(
                  text: 'Twyford Alcona Close Coupled Toilet Pan (Horizontal Outlet) ARI148WH Twyford Alcona Close Coupled Toilet Pan (Horizontal Outlet) ARI148WH Twyford Alcona Close Coupled Toilet Pan (Horizontal Outlet) ARI148WH',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.bookmark_outlined, size: 30,color: Colors.deepOrangeAccent,),
            ],
          ),
        ),
      ],
    );
  }
}