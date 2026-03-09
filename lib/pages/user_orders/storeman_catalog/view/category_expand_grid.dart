import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryExpandGrid extends StatelessWidget {
  CategoryExpandGrid({super.key});

  final controller = Get.find<StoremanCatalogController>();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: controller.categoriesList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final category = controller.categoriesList[index];
        return GestureDetector(
          onTap: () {
            controller.selectCategoryFromGrid(category.id ?? 0);

          },
          child: CardViewDashboardItem(
            padding: const EdgeInsets.all(14),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(category.thumbUrl ?? "",
                  width: 34,
                  height: 34,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.photo_outlined,
                        color: Colors.grey.shade300,
                        size: 34,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.photo_outlined,
                        size: 34,
                        color: Colors.grey.shade300,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: OrdersTitleTextView(
                    text: category.name,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    maxLine: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    color: primaryTextColor_(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}