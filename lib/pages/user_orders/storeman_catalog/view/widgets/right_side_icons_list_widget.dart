import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RightSideIconsListWidget extends StatelessWidget {
  RightSideIconsListWidget({super.key});

  final controller = Get.find<StoremanCatalogController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // EXPAND BUTTON
        expandButtonView(),
        SizedBox(height: 8,),
        //Categories List
        Expanded(
          child: Container(
            width: 55,
            color: Color(0xFFDADADA),
            child: Obx(() => ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: controller.categoriesList.length,
              itemBuilder: (context, index) {

                final item = controller.categoriesList[index];
                final isSelected =
                    controller.activeCategoryId.value == item.id;

                return GestureDetector(
                  onTap: () {
                    controller.selectCategory(item.id ?? 0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: 46,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? defaultAccentColor_(context) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        item.thumbUrl ?? "",
                        width: 28,
                        height: 28,
                        color: isSelected ? Colors.white : null,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Icon(
                            Icons.image_outlined,
                            size: 26,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey,
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.photo_outlined,
                            size: 26,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            )),
          ),
        ),
      ],
    );
  }

  // EXPAND BUTTON
  Widget expandButtonView() {
    return InkWell(
      onTap: () {
      controller.toggleCategoryGrid();
    },
      child: Container(
        width: 55,
        height: 60,
        color: Color(0xFFDADADA),
        child: Column(
          children: [
            SizedBox(width: 4,height: 5,),
            Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Obx(() => AnimatedRotation(
                turns: controller.isCategoryExpanded.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(Icons.open_in_full, color: Colors.grey,),
              )),
            ),
            SizedBox(width: 4,),
          ],
        ),
      ),
    );
  }
}