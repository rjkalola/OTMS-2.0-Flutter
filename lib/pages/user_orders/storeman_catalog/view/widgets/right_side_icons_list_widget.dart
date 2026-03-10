import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/icons/expand_icon_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RightSideIconsListWidget extends StatelessWidget {
  RightSideIconsListWidget({super.key});

  final controller = Get.find<StoremanCatalogController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Column(
        children: [
          // EXPAND BUTTON
          expandButtonView(),
          SizedBox(height: 8,),
          //Categories List
          Expanded(
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFDADADA).withAlpha(55),
                borderRadius: BorderRadius.circular(8), // corner radius added
              ),
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
                        height: 55,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? defaultAccentColor_(context)
                              : Colors.white,
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
                          width: 26,
                          height: 26,
                          color: isSelected ? Colors.white : null,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Icon(
                              Icons.image_outlined,
                              size: 26,
                              color: isSelected ? Colors.white : Colors.grey,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_outlined,
                              size: 26,
                              color: isSelected ? Colors.white : Colors.grey,
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
      ),
    );
  }

  // EXPAND BUTTON
  Widget expandButtonView() {
    return InkWell(
      onTap: () {
        controller.toggleCategoryGrid();
      },
      borderRadius: BorderRadius.circular(12), // ripple follows radius
      child: Container(
        width: 50,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFDADADA).withAlpha(55),
          borderRadius: BorderRadius.circular(12), // corner radius
        ),
        child: Column(
          children: [
            const SizedBox(width: 4, height: 7),
            Container(
              width: 35,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeConfig.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Obx(() => AnimatedRotation(
                turns: controller.isCategoryExpanded.value ? 0.5 : 0,
                duration: Duration(milliseconds: 300),
                child: ExpandIconWidget(),
              )),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}