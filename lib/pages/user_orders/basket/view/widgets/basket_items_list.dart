import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
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
              return InkWell(
                onTap: (){
                  var arguments = {
                    "product_id":product.productId
                  };
                  controller.moveToScreen(AppRoutes.productDetailsScreen, arguments);
                },
                child: CardViewDashboardItem(
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
                                            return  Center(
                                              child:  Icon(
                                                Icons.photo_outlined,
                                                size: 50,
                                                color: Colors.grey.shade300,
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
                                        child: TitleTextView(
                                          text: product.shortName ?? "",
                                          fontSize: 15,
                                          maxLine: 2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  SubtitleTextView(
                                    text: product.uuid ?? "",
                                    fontSize: 13,
                                    color: secondaryExtraLightTextColor_(context),
                                  ),
                                  const SizedBox(height: 4),
                                  TitleTextView(
                                    text: "${product.currency}${product.price ?? ""}",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 2),
                                  TitleTextView(
                                    text: "${'available_qty'.tr}: ${product.qty}",
                                    fontSize: 13,
                                    color: secondaryExtraLightTextColor_(context),
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
                                      OrderQuantityDisplayTextView(
                                        value: product.cartQty ?? 0,
                                        width: 52,
                                        height: 30,
                                      ),
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
                ),
              );
            },
          ),
        ));
  }

}
