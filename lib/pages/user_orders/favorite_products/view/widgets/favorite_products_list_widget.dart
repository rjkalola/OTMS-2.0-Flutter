import 'package:belcka/pages/user_orders/favorite_popup/favorite_popup_manager.dart';
import 'package:belcka/pages/user_orders/favorite_products/controller/favorite_products_controller.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteProductsListWidget extends StatefulWidget {
  const FavoriteProductsListWidget({super.key});

  @override
  State<FavoriteProductsListWidget> createState() =>
      _FavoriteProductsListWidgetState();
}

class _FavoriteProductsListWidgetState
    extends State<FavoriteProductsListWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteProductsController>();

    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.bookmarkList.length,
      itemBuilder: (context, index) {
        final product = controller.bookmarkList[index];
        final pageController = PageController();
        final isAdded = product.isCartProduct ?? false;
        final isInSet = product.isInSet ?? false;

        final isSubQuantity = product.isSubQty ?? false;

        final outOfStockCount = isSubQuantity
            ? ((product.cartQty ?? 0) -
            (int.parse(product.packOffQty ?? "0")))
            : ((product.cartQty ?? 0) - (product.qty ?? 0.0));

        final packOfUnit = product.packOfUnit ?? "";

        String availableQtyText =
            "${((product.qty ?? 0.0).toInt())}";

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
                      // --- UPDATED PRODUCT IMAGE SECTION ---
                      Column(
                        // Added a Column here to stack the Image Box and the Dots
                        children: [
                          Container(
                            width: 130,
                            // Enlarged from 110
                            height: 130,
                            // Enlarged from 110
                            decoration: BoxDecoration(
                              color: lightGreyColor(context),
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: PageView.builder(
                              controller: pageController,
                              itemCount:
                              product.productImages?.length ??
                                  0,
                              onPageChanged: (page) {
                                setState(() {
                                  controller.setCurrentImageIndex(
                                      index, page);
                                });
                              },
                              itemBuilder: (context, imgIndex) {
                                return InkWell(
                                  onTap: () {
                                    ImageUtils.moveToImagePreview(
                                        product.productImages ??
                                            [],
                                        imgIndex);
                                  },
                                  child: Center(
                                    // Centers the photo inside the container
                                    child: Image.network(
                                      product
                                          .productImages?[
                                      imgIndex]
                                          .thumbUrl ??
                                          "",
                                      fit: BoxFit.contain,
                                      // Changed to contain to ensure full photo is visible and centered
                                      errorBuilder: (context,
                                          error, stack) {
                                        return Center(
                                          child: Icon(
                                            Icons.photo_outlined,
                                            size: 50,
                                            color: Colors
                                                .grey.shade300,
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
                          // Gap between image and dots
                          // PageView Dots moved outside the Container
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: List.generate(
                              product.productImages?.length ?? 0,
                                  (dotIndex) {
                                final isActive =
                                    (controller.currentImageIndex[
                                    index] ??
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
                                        ? defaultAccentColor_(
                                        context)
                                        : Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // --- END OF UPDATED SECTION ---

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
                              color:
                              secondaryExtraLightTextColor_(
                                  context),
                            ),
                            const SizedBox(height: 8),
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
                              color:
                              secondaryExtraLightTextColor_(
                                  context),
                            ),
                            const SizedBox(height: 4),
                            //Favorite
                            InkWell(
                              onTap: (){
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.toggleBookmark(index);
                              },
                              child: Icon(product.isBookMark ?? true ? Icons.bookmark : Icons.bookmark_border,
                                color: product.isBookMark ?? true
                                    ? Colors.deepOrangeAccent
                                    : primaryTextColor_(context),
                                size: 20,
                              ),
                            )
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
                      if (isInSet)
                        Row(
                          children: [
                            FilledButton(
                              onPressed: () {
                                controller.fetchProductsSet(product.productId ?? 0);
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor:
                                  defaultAccentColor_(
                                      context)),
                              child: Text('Add Set'),
                            ),
                            SizedBox(
                              width: 8,
                            )
                          ],
                        ),

                      Spacer(),

                      !isAdded
                          ? PrimaryButton(
                          isFixSize: true,
                          width: 140,
                          height: 34,
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.w400,
                          buttonText: "add_to_cart".tr,
                          onPressed: () {
                            FocusManager.instance.primaryFocus
                                ?.unfocus();
                            if (isAdded) {
                              controller.toggleRemoveCart(
                                  index);
                            } else {
                              controller.toggleAddToCart(
                                  index, 1);
                            }
                          })
                          : ProductQuantityChangeWidget(
                        focusNode: product.qtyFocusNode,
                        isSubQuantity: isSubQuantity,
                        quantity:
                        (product.cartQty ?? 0).toInt(),
                        unit: packOfUnit,
                        onChanged: (value) {
                          controller.updateSubQty(
                              index, value);
                          controller.toggleAddToCart(
                              index, value,);
                        },
                        onIncrease: () {
                          controller.increaseQty(index);
                          final newQty = (product.cartQty ?? 0).toInt();
                          controller.toggleAddToCart(
                              index, newQty);
                        },
                        onDecrease: () {
                          FocusManager.instance.primaryFocus
                              ?.unfocus();
                          controller.decrementOrRemoveFromCart(
                              index);
                        },
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
