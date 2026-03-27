import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/icons/bookmark_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanProductsListWidget extends StatefulWidget {
  const StoremanProductsListWidget({super.key});

  @override
  State<StoremanProductsListWidget> createState() =>
      _StoremanProductsListWidgetState();
}

class _StoremanProductsListWidgetState extends State<StoremanProductsListWidget> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoremanCatalogController>();
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.products.length,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            final pageController = PageController();
            final isAdded = product.isCartProduct ?? false;

            final isSubQuantity = product.isSubQty ?? false;

            final outOfStockCount = isSubQuantity
                ? ((product.cartQty ?? 0) -
                    (int.parse(product.packOffQty ?? "0")))
                : ((product.cartQty ?? 0) - (product.qty ?? 0.0));

            final packOfUnit = product.packOfUnit ?? "";

            String availableQtyText = "${((product.qty ?? 0.0).toInt())}";

            return GestureDetector(
              onTap: () {
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  return;
                }
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
                                        controller.setCurrentImageIndex(
                                            index, page);
                                      });
                                    },
                                    itemBuilder: (context, imgIndex) {

                                      return InkWell(
                                        onTap: (){
                                          ImageUtils.moveToImagePreview(product.productImages ?? [], imgIndex);
                                        },
                                        child: Image.network(
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
                                        ),
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

                                    InkWell(
                                        onTap: (){
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controller.toggleBookmark(index);
                                          product.isBookMark = !(product.isBookMark??false);
                                          controller.products.refresh();
                                        },
                                        child: Icon(product.isBookMark ?? true ? Icons.bookmark : Icons.bookmark_border,
                                          size: 20, color: product.isBookMark ?? true
                                              ? Colors.deepOrangeAccent
                                              : primaryTextColor_(context),)),
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
                          // Amazon-style: show quantity controls only when item is in cart
                          if (isAdded) ...[
                            ProductQuantityWidget(
                              focusNode: controller.qtyFocusNodes[index],
                              isSubQuantity: isSubQuantity,
                              quantity: (product.cartQty ?? 0).toInt(),
                              unit: packOfUnit,
                              onChanged: (value) {
                                controller.updateSubQty(index, value);
                                controller.toggleAddToCart(index, value);
                              },
                              onIncrease: () {
                                controller.increaseQty(index);
                                final newQty =
                                    (controller.products[index].cartQty ?? 0)
                                        .toInt();
                                controller.toggleAddToCart(index, newQty);
                              },
                              onDecrease: () {
                                final product = controller.products[index];
                                final currentQty =
                                    (product.cartQty ?? 0).toInt();
                                if (currentQty <= 1) return;
                                controller.decreaseQty(index);
                                final newQty =
                                    (controller.products[index].cartQty ?? 0)
                                        .toInt();
                                controller.toggleAddToCart(index, newQty);
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                          Spacer(),

                          if (isAdded)
                          GestureDetector(
                            onTap: (){
                              FocusManager.instance.primaryFocus?.unfocus();
                              controller.toggleRemoveCart(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ImageUtils.setSvgAssetsImage(
                                path: Drawable.deleteIcon,
                                width: 18,
                                height: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          if (!isAdded)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 34),
                              backgroundColor: isAdded
                                  ? Colors.redAccent.shade200
                                  : Colors.green,
                              foregroundColor: Colors.white,
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
                                controller.increaseQty(index);
                                controller.toggleAddToCart(index, 1);
                              }
                            },
                            icon: isAdded
                                ? ImageUtils.setSvgAssetsImage(
                                    path: Drawable.deleteIcon,
                                    width: 18,
                                    height: 18,
                                    color: Colors.white,
                                  )
                                : CartIconWidget(
                                    color: Colors.white,
                                    size: 16,
                                  ),
                            label: Text(
                              isAdded ? "remove".tr : "add_to_cart".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
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
