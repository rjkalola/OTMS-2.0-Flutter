import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:get/get.dart';

class CategoryExpandGrid extends StatelessWidget {
  CategoryExpandGrid({super.key});

  final controller = Get.find<StoremanCatalogController>();
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ReorderableBuilder(
        scrollController: _scrollController,
        onReorderPositions: (positions) {
          final info = positions.first;
          controller.onReorderCategory(info.oldIndex, info.newIndex);
        },
        dragChildBoxDecoration: const BoxDecoration(color: Colors.transparent),
        builder: (children) {
          return GridView(
            key: _gridViewKey,
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: children,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
          );
        },
        children: List.generate(
          controller.categoriesList.length,
          (index) {
            UserOrdersCategoriesInfo info = controller.categoriesList[index];
            return GestureDetector(
              key: Key((info.id ?? index).toString()),
              onTap: () {
                controller.selectCategoryFromGrid(info.id ?? 0);
              },
              child: CardViewDashboardItem(
                  borderRadius: 16,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(9, 9, 9, 0),
                          alignment: Alignment.bottomCenter,
                          child: !StringHelper.isEmptyString(info.thumbUrl ?? "")
                              ? Image.network(
                                  info.thumbUrl ?? "",
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, url, error) =>
                                      ImageUtils.getEmptyViewContainer(
                                          width: 70,
                                          height: 70,
                                          borderRadius: 0),
                                )
                              : ImageUtils.getEmptyViewContainer(
                                  width: 70, height: 70, borderRadius: 0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                        height: 40,
                        child: TitleTextView(
                          text: info.name ?? "",
                          fontSize: 13,
                          textAlign: TextAlign.center,
                          maxLine: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
