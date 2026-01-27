import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_controller.dart';
import 'package:belcka/pages/user_orders/categories/view/widgets/user_orders_category_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOrdersCategoriesList extends StatelessWidget {
  UserOrdersCategoriesList({super.key});

  final controller = Get.put(UserOrdersCategoriesController());

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: controller.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        return UserOrdersCategoryCard(item: controller.categories[index]);
      },
    );
  }
}
