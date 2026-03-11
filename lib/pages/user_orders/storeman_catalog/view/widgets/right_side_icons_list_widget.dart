import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/icons/expand_icon_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RightSideIconsListWidget extends StatelessWidget {
  RightSideIconsListWidget({super.key});

  final controller = Get.find<StoremanCatalogController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isVisible = controller.isRightSideListEnable.value;
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 9, 0),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: isVisible ? 58 : 0,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADADA).withAlpha(55),
                  ),
                  child: Column(
                    children: [
                      // EXPAND BUTTON
                      expandButtonView(),
                      const SizedBox(
                        height: 8,
                      ),
                      //Categories List
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 14, right: 8),
                          width: 36,
                          child: ListView.builder(
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Container(
                                    width: 36,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                          width: 2,
                                          color: isSelected
                                              ? defaultAccentColor_(context)
                                              : Colors.white),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
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
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Icon(
                                          Icons.image_outlined,
                                          size: 26,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.image_outlined,
                                          size: 26,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.isRightSideListEnable.value =
                      !controller.isRightSideListEnable.value;
                },
                child: Container(
                  width: 16,
                  height: 66,
                  decoration: AppUtils.getDashboardItemDecoration(
                      color: Colors.blueAccent),
                  child: Icon(
                    isVisible
                        ? Icons.arrow_forward_ios_outlined
                        : Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // EXPAND BUTTON
  Widget expandButtonView() {
    return InkWell(
      onTap: () {
        controller.toggleCategoryGrid();
      }, // ripple follows radius
      child: Column(
        children: [
          const SizedBox(width: 4, height: 7),
          Container(
            width: 36,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Obx(() => AnimatedRotation(
                  turns: controller.isCategoryExpanded.value ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: ExpandIconWidget(color: Colors.black54,),
                )),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
