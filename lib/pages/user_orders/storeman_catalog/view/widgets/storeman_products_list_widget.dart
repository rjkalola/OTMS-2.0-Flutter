import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/icons/bookmark_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanProductsListWidget extends StatefulWidget {
  const StoremanProductsListWidget({
    super.key,
  });

  @override
  State<StoremanProductsListWidget> createState() =>
      _StoremanProductsListWidgetState();
}

class _StoremanProductsListWidgetState
    extends State<StoremanProductsListWidget> {
  final controller = Get.find<StoremanCatalogController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.products.length,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            final pageController = PageController();
            final isAdded = product.isCartProduct ?? false;

            final isSubQuantity = product.isSubQty ?? false;
            //final outOfStockCount = ((product.cartQty ?? 0) - (product.qty ?? 0.0));

            final outOfStockCount = isSubQuantity
                ? ((product.cartQty ?? 0) -
                    (int.parse(product.packOffQty ?? "")))
                : ((product.cartQty ?? 0) - (product.qty ?? 0.0));

            final packOfUnitName = product.packOfUnitName ?? "";
            final packOfUnit = product.packOfUnit ?? "";

            String availableQtyText = "${((product.qty ?? 0.0).toInt())}";

            return GestureDetector(
              onTap: () {
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                  // Keyboard is open → close it
                  FocusManager.instance.primaryFocus?.unfocus();
                  return;
                }
                // Keyboard already closed → navigate
                var arguments = {"product_id": product.productId};
                controller.moveToScreen(
                  AppRoutes.productDetailsScreen,
                  arguments,
                );
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
                            width: 110,
                            height: 110,
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
                                    itemCount:
                                        product.productImages?.length ?? 0,
                                    onPageChanged: (page) {
                                      setState(() {
                                        controller.currentImageIndex[index] =
                                            page;
                                      });
                                    },
                                    itemBuilder: (context, imgIndex) {
                                      return Image.network(
                                        product.productImages?[imgIndex]
                                                .thumbUrl ??
                                            "",
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) {
                                          return Center(
                                            child: Icon(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TitleTextView(
                                          text:
                                              "${product.currency}${product.marketPrice ?? ""}",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        TitleTextView(
                                          text:
                                              "${'qty'.tr}: $availableQtyText",
                                          fontSize: 13,
                                          color: secondaryExtraLightTextColor_(
                                              context),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                        icon: product.isBookMark ?? true
                                            ? Icon(Icons.bookmark)
                                            : BookmarkIconWidget(),
                                        color: product.isBookMark ?? true
                                            ? Colors.deepOrangeAccent
                                            : primaryTextColor_(context),
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controller.toggleBookmark(index);
                                        })
                                  ],
                                ),
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
                          ProductQuantityWidget(
                            focusNode: controller.qtyFocusNodes[index],
                            isSubQuantity: isSubQuantity,
                            quantity:(product.cartQty ?? 0).toInt(),
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
                                controller.decreaseQty(index);
                              });
                            },
                          ),
                          Spacer(),
                          // Add to Cart Button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 34),
                              backgroundColor: (isAdded)
                                  ? defaultAccentColor_(context)
                                  : Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (isAdded) {
                                controller.toggleRemoveCart(index);
                              } else {
                                if ((product.cartQty ?? 0) > 0) {
                                  controller.toggleAddToCart(
                                      index, (product.cartQty ?? 0).toInt());
                                }
                                else{
                                  AppUtils.showToastMessage(
                                      'msg_add_at_least_one_qty'.tr);
                                }
                              }
                            },
                            icon: CartIconWidget(
                              color: Colors.white,
                              size: 16,
                            ),
                            label: TitleTextView(
                              text: (isAdded) ? "added".tr : "add_to_cart".tr,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      // OUT OF STOCK MESSAGE
                      if (isAdded)
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
        ));
  }
}
