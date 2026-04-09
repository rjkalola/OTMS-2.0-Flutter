import 'package:belcka/pages/user_orders/hire_module/create_hire_order/controller/create_hire_order_controller.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/view/widgets/user_hire_product_list_item.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateHireOrderProductList extends StatelessWidget {
  final controller = Get.put(CreateHireOrderController());

  final List<ProductInfo> products;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  CreateHireOrderProductList({
    super.key,
    required this.products,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: shrinkWrap,
              physics: physics ?? const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = products[index];
                return UserHireProductListItem(
                  item: item,
                  isCartButtonVisible: false,
                  onListItem: () {
                    // Handle item click
                  },
                  onProductImageItem: AppUtils.onHireProductImageItem(productId: item.productId??0),
                );
              },
            ),
          )
        : Center(
            child: NoDataFoundWidget(),
          );
  }
}
