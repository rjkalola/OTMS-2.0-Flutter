import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
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
    return Obx(() => Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: controller.cartList.length,
            itemBuilder: (context, index) {
              final product = controller.cartList[index];
              final pageController = PageController();

              final isSubQuantity = product.isSubQty ?? false;
              final outOfStockCount = isSubQuantity
                  ? ((product.cartQty ?? 0) -
                      (int.parse(product.packOffQty ?? "")))
                  : ((product.cartQty ?? 0) - (product.qty ?? 0.0));

              final packOfUnitName = product.packOfUnitName ?? "";
              final packOfUnit = product.packOfUnit ?? "";
              String availableQtyText = "${((product.qty ?? 0.0).toInt())}";

              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (FocusScope.of(context).hasFocus) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    var arguments = {"product_id": product.productId};
                    controller.moveToScreen(
                        AppRoutes.productDetailsScreen, arguments);
                  }
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
                            Column(
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: lightGreyColor(context),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: PageView.builder(
                                    controller: pageController,
                                    itemCount:
                                        product.productImages?.length ?? 0,
                                    onPageChanged: (page) {
                                      setState(() {
                                        controller.currentImageIndex[index] =
                                            page;
                                      });
                                    },
                                    itemBuilder: (context, imgIndex) {
                                      return InkWell(
                                        onTap: () {
                                          ImageUtils.moveToImagePreview(
                                              product.productImages ?? [],
                                              imgIndex);
                                        },
                                        child: Center(
                                          child: Image.network(
                                            product.productImages?[imgIndex]
                                                    .thumbUrl ??
                                                "",
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stack) {
                                              return Center(
                                                child: Icon(
                                                  Icons.photo_outlined,
                                                  size: 50,
                                                  color: Colors.grey.shade300,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    product.productImages?.length ?? 0,
                                    (dotIndex) {
                                      final isActive = (controller
                                                  .currentImageIndex[index] ??
                                              0) ==
                                          dotIndex;
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        width: isActive ? 8 : 6,
                                        height: isActive ? 8 : 6,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isActive
                                              ? defaultAccentColor_(context)
                                              : Colors.grey[400],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 12),
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color:
                                        secondaryExtraLightTextColor_(context),
                                  ),
                                  const SizedBox(height: 4),
                                  TitleTextView(
                                    text:
                                        "${product.currency}${product.marketPrice ?? ""}",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 2),
                                  TitleTextView(
                                    text:
                                        "${'available_qty'.tr}: $availableQtyText",
                                    fontSize: 13,
                                    color:
                                        secondaryExtraLightTextColor_(context),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: dividerColor_(context),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            ProductQuantityChangeWidget(
                              focusNode: controller.qtyFocusNodes[index],
                              isSubQuantity: isSubQuantity,
                              quantity: (product.cartQty ?? 0).toInt(),
                              unit: packOfUnit,
                              onChanged: (value) {
                                controller.updateSubQty(index, value);
                              },
                              onIncrease: () {
                                setState(() {
                                  controller.increaseQty(index);
                                });
                              },
                              onDecrease: () {
                                setState(() {
                                  controller.decrementOrRemoveFromCart(index);
                                });
                              },
                            ),
                            // Spacer(),
                            // ElevatedButton.icon(
                            //   style: ElevatedButton.styleFrom(
                            //     minimumSize: const Size(0, 34),
                            //     backgroundColor: Colors.redAccent.shade200,
                            //     foregroundColor: Colors.white,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     padding: const EdgeInsets.symmetric(
                            //         vertical: 0, horizontal: 12),
                            //   ),
                            //   onPressed: () {
                            //     FocusManager.instance.primaryFocus?.unfocus();
                            //     controller.toggleRemoveCart(index);
                            //   },
                            //   icon: ImageUtils.setSvgAssetsImage(
                            //     path: Drawable.deleteIcon,
                            //     width: 18,
                            //     height: 18,
                            //     color: Colors.white,
                            //   ),
                            //   label: Text("remove".tr,
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.w400,
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        // OUT OF STOCK MESSAGE
                        if ((product.qty ?? 0) >= 0)
                          OutOfStockBanner(
                            itemCount: (outOfStockCount).toInt(),
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
