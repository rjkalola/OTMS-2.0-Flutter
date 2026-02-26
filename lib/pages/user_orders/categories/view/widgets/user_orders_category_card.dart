import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_controller.dart';
import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_info.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOrdersCategoryCard extends StatelessWidget {
  final UserOrdersCategoriesInfo item;
   UserOrdersCategoryCard({super.key, required this.item});

  final controller = Get.put(UserOrdersCategoriesController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        var arguments = {
          "category_ids":item.id
        };
        controller.moveToScreen(AppRoutes.storemanCatalogScreen, arguments);
      },
      child: CardViewDashboardItem(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(item.thumbUrl ?? "",
              width: 42,
              height: 42,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    size: 42,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 42,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: OrdersTitleTextView(
                text: item.name,
                textAlign: TextAlign.center,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                maxLine: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}