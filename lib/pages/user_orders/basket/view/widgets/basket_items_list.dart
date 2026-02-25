import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasketItemsList extends StatefulWidget {
  const BasketItemsList({super.key});

  @override
  State<BasketItemsList> createState() => _BasketItemsListState();
}
class _BasketItemsListState extends State<BasketItemsList> {

  final controller = Get.put(BasketController());

  @override
  Widget build(BuildContext context) {
    return Obx(
            () => Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: controller.cartList.length,
            itemBuilder: (context, index) {
              final product = controller.cartList[index];
              final pageController = PageController();

              final outOfStockCount = product.cartQty ?? 0 - (product.qty ?? 0);
              return CardViewDashboardItem(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image Carousel
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              children: [
                                Expanded(
                                  child: PageView.builder(
                                    controller: pageController,
                                    itemCount: product.productImages?.length ?? 0,
                                    onPageChanged: (page) {
                                      setState(() {
                                        controller.currentImageIndex[index] = page;
                                      });
                                    },
                                    itemBuilder: (context, imgIndex) {
                                      return Image.network(
                                        product.productImages?[imgIndex].thumbUrl ?? "",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stack) {
                                          return const Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_rounded,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // PageView Dots
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: List.generate(
                                    product.productImages?.length ?? 0,
                                        (dotIndex) {
                                      final isActive =
                                          (controller.currentImageIndex[index] ??
                                              0) ==
                                              dotIndex;
                                      return AnimatedContainer(
                                        duration: const Duration(
                                            milliseconds: 200),
                                        width: isActive ? 8 : 6,
                                        height: isActive ? 8 : 6,
                                        margin:
                                        const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isActive
                                              ? defaultAccentColor_(context)
                                              : Colors.grey[500],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.sortName ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.uuid ?? "",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${product.currency ?? ""}${product.price ?? ""}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Available Qty: ${product.qty}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),

                                // Quantity Selector
                                Row(
                                  children: [
                                    OrderQuantityChangeButton(
                                        text: "-", onTap: (){
                                      setState(() {
                                        controller.decreaseQty(index);
                                      });

                                    }),
                                    SizedBox(width: 8),
                                    OrdersTitleTextView(text: "${product.cartQty ?? 0}",),
                                    SizedBox(width: 8),
                                    OrderQuantityChangeButton(
                                        text: "+", onTap: (){
                                      setState(() {
                                        controller.increaseQty(index);
                                      });
                                    }),
                                    SizedBox(width: 8),
                                    Spacer(),
                                    IconButton(icon:
                                    Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          controller.toggleRemoveCart(index);
                                        }),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // OUT OF STOCK MESSAGE
                      if ((product.qty ?? 0) >= 0)
                        OutOfStockBanner(
                          itemCount: outOfStockCount,
                          deliveryDays: 5,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

}
