import 'package:belcka/pages/common/model/dialog_title_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/stock_products_list/controller/stock_products_list_controller.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockProductsListFilterSheet extends StatelessWidget {
  final StockProductsListController controller;

  const StockProductsListFilterSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleView(title: 'filters'.tr),
              if (controller.isFilterResourcesLoading.value)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: CustomProgressbar(),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: DropDownTextField(
                    title: 'suppliers'.tr,
                    controller: controller.supplierController,
                    onPressed: controller.showSupplierFilterDialog,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: DropDownTextField(
                    title: 'category'.tr,
                    controller: controller.categoryController,
                    onPressed: controller.showCategoryFilterDialog,
                    borderRadius: 8,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.clearFilters,
                        child: Text(
                          'clear'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: primaryTextColor_(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PrimaryButton(
                        buttonText: 'apply'.tr,
                        isFixSize: true,
                        width: 100,
                        height: 42,
                        borderRadius: 22,
                        onPressed: controller.applyFilters,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
