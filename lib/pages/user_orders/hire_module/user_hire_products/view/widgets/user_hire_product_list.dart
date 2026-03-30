import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/controller/user_hire_product_controller.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/view/widgets/user_hire_product_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHireProductList extends StatelessWidget {
  final List<ProductInfo> products;
  const UserHireProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserHireProductController>();

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
                return UserHireProductListItem(
                  item: item,
                  isCartButtonVisible: true,
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
