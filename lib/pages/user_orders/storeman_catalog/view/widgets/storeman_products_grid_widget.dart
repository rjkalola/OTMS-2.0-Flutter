import 'package:belcka/pages/user_orders/favorite_popup/favorite_popup_manager.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_categories.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/products_loading_skeleton.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
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

class _StoremanProductsGridWidgetState extends State<StoremanProductsGridWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoremanCatalogController>();

    return Obx(() => RefreshIndicator(
      color: defaultAccentColor_(context),
      onRefresh: () async => await controller.fetchProducts(isRefresh: true),
      child: controller.isProductsLoading.value
          ? const ProductsLoadingSkeleton()
          : ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.fromLTRB(16, 8, 8, 0),
        itemCount: controller.categories.length,
        itemBuilder: (context, catIndex) {
          final category = controller.categories[catIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //CATEGORY HEADER
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.8),
                    border: Border(
                      left: BorderSide(
                          color: defaultAccentColor_(context),
                          width: 4),
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
                    ],
                  ),
                ),
              ),

              // GRID
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = getAdaptiveCount(constraints.maxWidth);
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 345,

                    ),
                    itemBuilder: (context, index) {
                      final product = category.products[index];
                      final pageController = PageController();
                      final layerLink = LayerLink();
                      final projectService = Get.find<ProjectService>();

                      return _buildGridViewProductCard(
                        context,
                        product,
                        controller,
                        index,
                        category,
                        pageController,
                        layerLink,
                        projectService,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    ));
  }

  Widget _buildGridViewProductCard(
      BuildContext context,
      ProductInfo product,
      StoremanCatalogController controller,
      int index,
      ProductCategories category,
      PageController pageController,
      LayerLink layerLink,
      ProjectService projectService,)
  {

    final isAdded = product.isCartProduct ?? false;
    final isSubQuantity = product.isSubQty ?? false;
    final packOfUnit = product.packOfUnit ?? "";

    return GestureDetector(
      onTap: () => controller.moveToScreen(
        AppRoutes.productDetailsScreen,
        {"product_id": product.productId},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: lightGreyColor(context).withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: lightGreyColor(context).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: lightGreyColor(context).withOpacity(0.5),
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: product.productImages?.length ?? 0,
                      onPageChanged: (page){
                        setState(() {
                          controller.setCurrentImageIndex(index, page);
                        });
                      },
                      itemBuilder: (context, imgIndex) {
                        return InkWell(
                          onTap: () {
                            ImageUtils.moveToImagePreview(product.productImages ?? [], imgIndex);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              product.productImages?[imgIndex].thumbUrl ?? "",
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (_, __, ___) => const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildBookmarkButton(context, product, controller, index, category, layerLink, projectService),
                ),
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      product.productImages?.length ?? 0,
                          (dotIndex) {
                        final isActive = (controller.currentImageIndex[index] ?? 0) == dotIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: isActive ? 12 : 4,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isActive ? defaultAccentColor_(context) : Colors.grey.withOpacity(0.4),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // CONTENT SECTION
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextView(
                    text: product.shortName ?? "",
                    fontSize: 13,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 2),
                  SubtitleTextView(
                    text: product.uuid ?? "",
                    fontSize: 10,
                    color: secondaryExtraLightTextColor_(context),
                  ),
                  const SizedBox(height: 8),
                  TitleTextView(
                    text:
                    "${product.currency}${product.marketPrice ?? ""}",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  SubtitleTextView(
                    text: "${'qty'.tr}: ${product.qty?.toInt()}",
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 12),

                  // ACTION BUTTON
                  Center(
                    child: !(isAdded)
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context, ProductInfo product, StoremanCatalogController controller,
      int index, ProductCategories category, LayerLink layerLink, ProjectService projectService) {
    bool isBookmarked = product.isBookMark ?? false;
    return Builder(builder: (ctx) {
      return GestureDetector(
        onTap: () {
          if (isBookmarked) {
            controller.toggleBookmark(index, category, product.folderId ?? 0);
            product.isBookMark = false;
            controller.categories.refresh();
          } else {
            FavoritePopupManager.show(
              context: ctx,
              layerLink: layerLink,
              folders: projectService.folderList,
              onProjectSelected: (folder) {
                controller.toggleBookmark(index, category, folder.id ?? 0);
                product.isBookMark = true;
                controller.categories.refresh();
              },
            );
          }
        },
        child: CompositedTransformTarget(
          link: layerLink,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: isBookmarked ? Colors.orange : Colors.black54,
              size: 18,
            ),
          ),
        ),
      );
    });
  }

  int getAdaptiveCount(double width) {
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }
}