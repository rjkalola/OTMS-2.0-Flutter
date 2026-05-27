import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/icons/expand_icon_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RightSideIconsListWidget extends StatelessWidget {
  RightSideIconsListWidget({super.key});

  final controller = Get.find<StoremanCatalogController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isVisible =
          controller.isRightSideListEnable.value;
      return ExcludeSemantics(
        child: Container(
          height: 55,
          margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [

              // MENU BUTTON
              /*
              GestureDetector(
                onTap: () {
                  controller.isRightSideListEnable.value =
                  !isVisible;
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isVisible
                        ? Icons.menu_open_rounded
                        : Icons.menu_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              */

              if (isVisible) ...[
                // CATEGORY LIST
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics:
                    const BouncingScrollPhysics(),
                    itemCount:
                    controller.categoriesList.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 10),
                    itemBuilder: (context, index) {

                      final item =
                      controller.categoriesList[index];

                      final bool isSelected =
                          controller.activeCategoryId.value ==
                              item.id;

                      return GestureDetector(
                        onTap: () {
                          controller.selectCategory(
                              item.id ?? 0);
                        },
                        child: Container(
                          width: 30,
                          height: 70,
                          margin:
                          const EdgeInsets.symmetric(
                              vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? defaultAccentColor_(context)
                                : dashBoardBgColor_(context),
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Image.network(
                              item.thumbUrl ?? "",
                              width: 26,
                              height: 26,
                              color: primaryTextColor_(context),
                              errorBuilder:
                                  (_, __, ___) {
                                return Icon(
                                  Icons.image_outlined,
                                  size: 24,
                                  color: isSelected
                                      ? backgroundColor_(context)
                                      : Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),
                // EXPAND BUTTON
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    controller.toggleCategoryGrid();
                  },
                  child: Container(
                    width: 35,
                    height: 45,
                    decoration: BoxDecoration(
                      color: backgroundColor_(context),
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: AnimatedRotation(
                        turns: controller
                            .isCategoryExpanded.value
                            ? 0.5
                            : 0,
                        duration:
                        const Duration(milliseconds: 300),
                        child: ExpandIconWidget(
                          color: primaryTextColor_(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
