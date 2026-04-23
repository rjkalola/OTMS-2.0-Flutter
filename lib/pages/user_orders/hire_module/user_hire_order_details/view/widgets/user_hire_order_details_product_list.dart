import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/view/widgets/user_hire_order_details_product_list_item.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/view/widgets/user_hire_product_list_item.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';

class UserHireOrderDetailsProductList extends StatelessWidget {
  final List<ProductInfo> products;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const UserHireOrderDetailsProductList({
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
        physics: physics ?? const ClampingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = products[index];
          return UserHireOrderDetailsProductListItem(
            item: item,
            isCartButtonVisible: false,
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
