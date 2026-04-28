import 'package:belcka/pages/user_orders/favorite_popup/add_folder_view.dart';
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
            await controller.fetchProducts(isRefresh: true);
          },
          child: controller.isProductsLoading.value
              ? _ProductsLoadingSkeleton()
              : ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
            itemCount: controller.categories.length,
            controller: controller.scrollController,
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
              /*
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${category.products.length} ${'items'.tr}",
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        )
                        */
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

                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        // 1. The Image Box (Increased Size)
                                        Container(
                                          width: 110, // Increased from 130
                                          height: 110, // Increased from 130
                                          decoration: BoxDecoration(
                                            color: lightGreyColor(context),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: PageView.builder(
                                            controller: pageController,
                                            itemCount: product.productImages?.length ?? 0,
                                            onPageChanged: (page) {
                                              setState(() {
                                                controller.setCurrentImageIndex(index, page);
                                              });
                                            },
                                            itemBuilder: (context, imgIndex) {
                                              return InkWell(
                                                onTap: () {
                                                  ImageUtils.moveToImagePreview(product.productImages ?? [], imgIndex);
                                                },
                                                child: SizedBox.expand(
                                                  child: Image.network(
                                                    product.productImages?[imgIndex].thumbUrl ?? "",
                                                    fit: BoxFit.fill,
                                                    alignment: Alignment.center,
                                                    errorBuilder: (context, error, stack) {
                                                      return Center(
                                                        child: Icon(Icons.photo_outlined, size: 50, color: Colors.grey.shade300),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        // 2. The Dots (Positioned on top of the image)
                                        Positioned(
                                          bottom: 10, // Distance from the bottom of the image
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(
                                              product.productImages?.length ?? 0,
                                                  (dotIndex) {
                                                final isActive = (controller.currentImageIndex[index] ?? 0) == dotIndex;
                                                return AnimatedContainer(
                                                  duration: const Duration(milliseconds: 200),
                                                  width: isActive ? 8 : 6,
                                                  height: isActive ? 8 : 6,
                                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isActive
                                                        ? defaultAccentColor_(context)
                                                        : secondaryTextColor_(context), // White dots look better on images
                                                    boxShadow: [
                                                      if (isActive)
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.2),
                                                          blurRadius: 2,
                                                        )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
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
                                          // Favorite Button Section
                                          Builder(
                                            builder: (buttonContext) {
                                              bool isBookmarked = product.isBookMark ?? false;
                                              return InkWell(
                                                onTap: () {
                                                  if (isBookmarked) {
                                                    // Un-bookmarking
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    controller.toggleBookmark(index, category, product.folderId ?? 0);
                                                    product.isBookMark = false;
                                                    controller.categories.refresh();
                                                  } else {
                                                    //Bookmarking
                                                    if (projectService.folderList.isEmpty) {
                                                      // Show Add Folder Dialog
                                                      showDialog(
                                                        context: buttonContext,
                                                        barrierDismissible: true,
                                                        builder: (BuildContext context) {
                                                          return Dialog(
                                                            backgroundColor: Colors.transparent,
                                                            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                                                            child: Container(
                                                              padding: const EdgeInsets.all(20),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(20),
                                                                boxShadow: const [
                                                                  BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))
                                                                ],
                                                              ),
                                                              child: AddFolderView(
                                                                folders: [],
                                                                onCancel: () => Navigator.pop(context),
                                                                onAdded: (folderName, projectId) async {
                                                                  Navigator.pop(context);
                                                                  final newFolder = await projectService.toggleCreateNewFolder(folderName, projectId);

                                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                                  controller.toggleBookmark(index, category, newFolder?.id ?? 0);
                                                                  product.isBookMark = true;
                                                                  controller.categories.refresh();
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      // Show the Popup Manager with the CORRECT buttonContext
                                                      FavoritePopupManager.show(
                                                        context: buttonContext, // This ensures position is calculated correctly
                                                        layerLink: _layerLink,
                                                        folders: projectService.folderList,
                                                        onProjectSelected: (folder) {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          controller.toggleBookmark(index, category, folder.id ?? 0);
                                                          product.isBookMark = true;
                                                          controller.categories.refresh();
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                                child: CompositedTransformTarget(
                                                  link: _layerLink,
                                                  child: Icon(
                                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                    color: isBookmarked ? Colors.deepOrangeAccent : primaryTextColor_(buttonContext),
                                                    size: 20,
                                                  ),
                                                ),
                                              );
                                            },
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
                                            child: Text('add_set'.tr),
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
                                              controller
                                                  .decrementOrRemoveFromCart(
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

class _ProductsLoadingSkeleton extends StatelessWidget {
  const _ProductsLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const _SkeletonProductCard(),
            SizedBox(height: 6,)
            // if (index < 4)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 8),
            //     child: _SkeletonBox(
            //       height: 8,
            //       width: double.infinity,
            //       borderRadius: 2,
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}

class _SkeletonProductCard extends StatelessWidget {
  const _SkeletonProductCard();

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _SkeletonCircle(size: 90),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(
                        height: 14,
                        width: double.infinity,
                        borderRadius: 8,
                      ),
                      SizedBox(height: 8),
                      _SkeletonBox(
                        height: 14,
                        width: 220,
                        borderRadius: 8,
                      ),
                      SizedBox(height: 8),
                      _SkeletonBox(
                        height: 14,
                        width: 180,
                        borderRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _SkeletonBox(
              height: 1,
              width: double.infinity,
              borderRadius: 9,
            ),
            // const SizedBox(height: 8),
            // const _SkeletonBox(
            //   height: 18,
            //   width: double.infinity,
            //   borderRadius: 9,
            // ),
            // const SizedBox(height: 8),
            // const _SkeletonBox(
            //   height: 18,
            //   width: 260,
            //   borderRadius: 9,
            // ),
            const SizedBox(height: 12),
            Row(
              children: const [
                _SkeletonBox(height: 20, width: 20, borderRadius: 10),
                SizedBox(width: 6),
                _SkeletonBox(height: 20, width: 20, borderRadius: 10),
                SizedBox(width: 6),
                _SkeletonBox(height: 20, width: 20, borderRadius: 10),
                SizedBox(width: 6),
                _SkeletonBox(height: 20, width: 48, borderRadius: 10),
                Spacer(),
                _SkeletonBox(height: 24, width: 140, borderRadius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const _SkeletonBox({
    required this.height,
    required this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedSkeletonBox(
      height: height,
      width: width,
      borderRadius: borderRadius,
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;

  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return _AnimatedSkeletonBox(
      height: size,
      width: size,
      borderRadius: 0,
    );
  }
}

class _AnimatedSkeletonBox extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;

  const _AnimatedSkeletonBox({
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  State<_AnimatedSkeletonBox> createState() => _AnimatedSkeletonBoxState();
}

class _AnimatedSkeletonBoxState extends State<_AnimatedSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE1E5EA);
    final highlight = isDark ? const Color(0xFF565656) : const Color(0xFFF7F9FB);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final slide = _controller.value;
        final start = (slide - 1).clamp(-1.0, 1.0);
        final end = (slide + 1).clamp(-1.0, 2.0);
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(start, 0),
              end: Alignment(end, 0),
              colors: [base, highlight, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}
