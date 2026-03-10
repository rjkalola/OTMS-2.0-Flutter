import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/storeman_app/storeman_hire_products/controller/storeman_hire_product_controller.dart';
import 'package:belcka/storeman_app/storeman_hire_products/view/widgets/storeman_hire_product_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanHireProductList extends StatelessWidget {
  final List<ProductInfo> products;
  const StoremanHireProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoremanHireProductController>();
    
    return products.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = products[index];
                return StoremanHireProductListItem(
                  item: item,
                  onAdd: () {
                    item.cartQty = (item.cartQty ?? 0) + 1;
                    controller.productsList.refresh();
                  },
                  onRemove: () {
                    if ((item.cartQty ?? 0) > 0) {
                      item.cartQty = (item.cartQty ?? 0) - 1;
                      controller.productsList.refresh();
                    }
                  },
                  onListItem: () {
                    // Handle item click
                  },
                );
              },
            ),
          )
        : Center(
            child: NoDataFoundWidget(),
          );
  }
}
