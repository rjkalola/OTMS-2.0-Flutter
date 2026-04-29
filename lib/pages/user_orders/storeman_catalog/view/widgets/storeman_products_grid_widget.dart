import 'package:belcka/pages/user_orders/favorite_popup/favorite_popup_manager.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/products_loading_skeleton.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class StoremanProductsGridWidget extends StatefulWidget {
  const StoremanProductsGridWidget({super.key});

  @override
  State<StoremanProductsGridWidget> createState() =>
      _StoremanProductsGridWidgetState();
}

class _StoremanProductsGridWidgetState
    extends State<StoremanProductsGridWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoremanCatalogController>();

    return Obx(() => RefreshIndicator(
      onRefresh: () async {
        await controller.fetchProducts(isRefresh: true);
      },
      child: controller.isProductsLoading.value
          ? ProductsLoadingSkeleton()
          : ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: controller.categories.length,
        itemBuilder: (context, catIndex) {
          final category = controller.categories[catIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // CATEGORY TITLE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.95),
                  border: Border(
                    left: BorderSide(
                        color: defaultAccentColor_(context),
                        width: 4),
                  ),
                ),
                child: TitleTextView(
                  text: category.categoryName.toUpperCase(),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              // GRID
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: category.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.60,
                  mainAxisExtent: 310,
                ),
                itemBuilder: (context, index) {
                  final product = category.products[index];

                  final pageController = PageController();
                  final isAdded =
                      product.isCartProduct ?? false;
                  final isSubQuantity =
                      product.isSubQty ?? false;

                  final packOfUnit =
                      product.packOfUnit ?? "";

                  String availableQtyText =
                      "${((product.qty ?? 0.0).toInt())}";

                  final LayerLink layerLink = LayerLink();
                  final projectService =
                  Get.find<ProjectService>();

                  return GestureDetector(
                    onTap: () {
                      controller.moveToScreen(
                        AppRoutes.productDetailsScreen,
                        {"product_id": product.productId},
                      );
                    },
                    child: CardViewDashboardItem(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            // IMAGE WITH PAGEVIEW
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: lightGreyColor(context),
                                  child: PageView.builder(
                                    controller: pageController,
                                    itemCount: product
                                        .productImages
                                        ?.length ??
                                        0,
                                    onPageChanged: (page) {
                                      controller
                                          .setCurrentImageIndex(
                                          index, page);
                                    },
                                    itemBuilder:
                                        (context, imgIndex) {
                                      return Image.network(
                                        product.productImages?[
                                        imgIndex]
                                            .thumbUrl ??
                                            "",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) =>
                                            Icon(Icons
                                                .photo_outlined),
                                      );
                                    },
                                  ),
                                ),

                                // DOTS
                                Positioned(
                                  bottom: 6,
                                  child: Row(
                                    children: List.generate(
                                      product.productImages
                                          ?.length ??
                                          0,
                                          (dotIndex) {
                                        final isActive =
                                            (controller
                                                .currentImageIndex[
                                            index] ??
                                                0) ==
                                                dotIndex;
                                        return Container(
                                          margin:
                                          const EdgeInsets
                                              .symmetric(
                                              horizontal: 2),
                                          width:
                                          isActive ? 7 : 5,
                                          height:
                                          isActive ? 7 : 5,
                                          decoration:
                                          BoxDecoration(
                                            shape:
                                            BoxShape.circle,
                                            color: isActive
                                                ? defaultAccentColor_(
                                                context)
                                                : Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // NAME
                            TitleTextView(
                              text: product.shortName ?? "",
                              fontSize: 13,
                              maxLine: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                            ),

                            const SizedBox(height: 4),

                            // UUID
                            SubtitleTextView(
                              text: product.uuid ?? "",
                              fontSize: 11,
                              color:
                              secondaryExtraLightTextColor_(
                                  context),
                            ),

                            const SizedBox(height: 6),

                            // PRICE
                            TitleTextView(
                              text:
                              "${product.currency}${product.marketPrice ?? ""}",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),

                            const SizedBox(height: 2),

                            // QTY
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TitleTextView(
                                  text:
                                  "${'qty'.tr}: $availableQtyText",
                                  fontSize: 11,
                                  color:
                                  secondaryExtraLightTextColor_(
                                      context),
                                ),
                                Builder(builder: (ctx) {
                                  bool isBookmarked =
                                      product.isBookMark ??
                                          false;

                                  return InkWell(
                                    onTap: () {
                                      if (isBookmarked) {
                                        controller.toggleBookmark(
                                            index,
                                            category,
                                            product.folderId ??
                                                0);
                                        product.isBookMark =
                                        false;
                                        controller.categories
                                            .refresh();
                                      } else {
                                        FavoritePopupManager
                                            .show(
                                          context: ctx,
                                          layerLink: layerLink,
                                          folders:
                                          projectService
                                              .folderList,
                                          onProjectSelected:
                                              (folder) {
                                            controller
                                                .toggleBookmark(
                                                index,
                                                category,
                                                folder.id ??
                                                    0);
                                            product
                                                .isBookMark = true;
                                            controller
                                                .categories
                                                .refresh();
                                          },
                                        );
                                      }
                                    },
                                    child:
                                    CompositedTransformTarget(
                                      link: layerLink,
                                      child: Icon(
                                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                        color: isBookmarked ? Colors.deepOrangeAccent : primaryTextColor_(context),
                                        size: 20,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),

                            Divider(
                              color: dividerColor_(context),
                            ),

                            // BOOKMARK
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                // CART
                                isAdded
                                    ? ProductQuantityChangeWidget(
                                  focusNode:
                                  product.qtyFocusNode,
                                  isSubQuantity:
                                  isSubQuantity,
                                  quantity: (product
                                      .cartQty ??
                                      0)
                                      .toInt(),
                                  unit: packOfUnit,
                                  onChanged: (v) {
                                    controller.updateSubQty(
                                        index, v, category);
                                    controller
                                        .toggleAddToCart(
                                        index,
                                        v,
                                        category);
                                  },
                                  onIncrease: () {
                                    controller.increaseQty(
                                        index, category);
                                  },
                                  onDecrease: () {
                                    controller
                                        .decrementOrRemoveFromCart(
                                        index,
                                        category);
                                  },
                                )
                                    : SizedBox(
                                  height: 30,
                                  child: PrimaryButton(
                                    isFixSize: true,
                                    width: 90,
                                    height: 30,
                                    fontSize: 11,
                                    color: Colors.green,
                                    buttonText:
                                    "add_to_cart".tr,
                                    onPressed: () {
                                      controller
                                          .increaseQty(
                                          index,
                                          category);
                                      controller
                                          .toggleAddToCart(
                                          index,
                                          1,
                                          category);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            ],
          );
        },
      ),
    ));
  }
}