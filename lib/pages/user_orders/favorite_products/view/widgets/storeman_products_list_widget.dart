import 'package:belcka/pages/user_orders/favorite_popup/favorite_popup_manager.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/icons/bookmark_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
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

class _StoremanProductsListWidgetState
    extends State<StoremanProductsListWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoremanCatalogController>();

    return Obx(() => RefreshIndicator(
          onRefresh: () async {
            await controller.fetchProducts();
          },
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
            itemCount: controller.categories.length,
            itemBuilder: (context, catIndex) {
              final category = controller.categories[catIndex];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.95),
                      border: Border(
                        left: BorderSide(
                            color: defaultAccentColor_(context),
                            width: 4), // Accent line
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TitleTextView(
                            text: category.categoryName.toUpperCase() ?? "",
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: primaryTextColor_(context),
                          ),
                        ),
                        //Show item count
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${category.products.length} items",
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.products.length,
                    itemBuilder: (context, index) {
                      final product = category.products[index];
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

                      final projectService = Get.find<ProjectService>();
                      final LayerLink _layerLink = LayerLink();

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
                                              FavoritePopupManager.show(
                                                context: context,
                                                layerLink: _layerLink,
                                                projects: projectService.projectsList,
                                                onProjectSelected: (project) {
                                                  print("Selected: ${project.name ?? ""}");
                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                  controller.toggleBookmark(index, category,project.id ?? 0);
                                                  product.isBookMark = !(product.isBookMark ??
                                                      false);
                                                  controller.categories.refresh();
                                                },
                                              );
                                            },
                                            child: CompositedTransformTarget(
                                              link: _layerLink,
                                              child: Icon(product.isBookMark ?? true ? Icons.bookmark : Icons.bookmark_border,
                                                color: product.isBookMark ?? true
                                                    ? Colors.deepOrangeAccent
                                                    : primaryTextColor_(context),
                                                size: 20,
                                              ),
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
                                              controller.fetchProductsSet(
                                                  product.productId ?? 0);
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

                                    // if (isAdded) ...[
                                    //   ProductQuantityWidget(
                                    //     focusNode: product.qtyFocusNode,
                                    //     isSubQuantity: isSubQuantity,
                                    //     quantity:
                                    //         (product.cartQty ?? 0).toInt(),
                                    //     unit: packOfUnit,
                                    //     onChanged: (value) {
                                    //       controller.updateSubQty(
                                    //           index, value, category);
                                    //       controller.toggleAddToCart(
                                    //           index, value, category);
                                    //     },
                                    //     onIncrease: () {
                                    //       controller.increaseQty(
                                    //           index, category);
                                    //       final newQty = (category
                                    //                   .products[index]
                                    //                   .cartQty ??
                                    //               0)
                                    //           .toInt();
                                    //       controller.toggleAddToCart(
                                    //           index, newQty, category);
                                    //     },
                                    //     onDecrease: () {
                                    //       final product =
                                    //           category.products[index];
                                    //       final currentQty =
                                    //           (product.cartQty ?? 0).toInt();
                                    //       if (currentQty <= 1) return;
                                    //       controller.decreaseQty(
                                    //           index, category);
                                    //       final newQty = (category
                                    //                   .products[index]
                                    //                   .cartQty ??
                                    //               0)
                                    //           .toInt();
                                    //       controller.toggleAddToCart(
                                    //           index, newQty, category);
                                    //     },
                                    //   ),
                                    //   const SizedBox(width: 8),
                                    // ],
                                    Spacer(),

                                    // if (isAdded)
                                    //   GestureDetector(
                                    //     onTap: () {
                                    //       FocusManager.instance.primaryFocus
                                    //           ?.unfocus();
                                    //       controller.toggleRemoveCart(
                                    //           index, category);
                                    //     },
                                    //     child: Container(
                                    //       padding: const EdgeInsets.all(6),
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.redAccent.shade200,
                                    //         borderRadius:
                                    //             BorderRadius.circular(6),
                                    //       ),
                                    //       child: ImageUtils.setSvgAssetsImage(
                                    //         path: Drawable.deleteIcon,
                                    //         width: 18,
                                    //         height: 18,
                                    //         color: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),

                                    // if (!isAdded)
                                    //   ElevatedButton.icon(
                                    //     style: ElevatedButton.styleFrom(
                                    //       minimumSize: const Size(0, 34),
                                    //       backgroundColor: isAdded
                                    //           ? Colors.redAccent.shade200
                                    //           : Colors.green,
                                    //       foregroundColor: Colors.white,
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(10),
                                    //       ),
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 0, horizontal: 12),
                                    //     ),
                                    //     onPressed: () {
                                    //       FocusManager.instance.primaryFocus?.unfocus();
                                    //       if (isAdded) {
                                    //         controller.toggleRemoveCart(index,category);
                                    //       } else {
                                    //         controller.increaseQty(index,category);
                                    //         controller.toggleAddToCart(index, 1,category);
                                    //       }
                                    //     },
                                    //     icon: isAdded
                                    //         ? ImageUtils.setSvgAssetsImage(
                                    //       path: Drawable.deleteIcon,
                                    //       width: 18,
                                    //       height: 18,
                                    //       color: Colors.white,
                                    //     )
                                    //         : CartIconWidget(
                                    //       color: Colors.white,
                                    //       size: 16,
                                    //     ),
                                    //     label: Text(
                                    //       isAdded ? "remove".tr : "add_to_cart".tr,
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 14,
                                    //       ),
                                    //     ),
                                    //   ),

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
                                                    index, category);
                                              } else {
                                                controller.increaseQty(
                                                    index, category);
                                                controller.toggleAddToCart(
                                                    index, 1, category);
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
                                                  index, value, category);
                                              controller.toggleAddToCart(
                                                  index, value, category);
                                            },
                                            onIncrease: () {
                                              controller.increaseQty(
                                                  index, category);
                                              final newQty = (category
                                                          .products[index]
                                                          .cartQty ??
                                                      0)
                                                  .toInt();
                                              controller.toggleAddToCart(
                                                  index, newQty, category);
                                            },
                                            onDecrease: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              controller.decrementOrRemoveFromCart(
                                                  index, category);
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
                  ),
                ],
              );
            },
          ),
        ));
  }
}
