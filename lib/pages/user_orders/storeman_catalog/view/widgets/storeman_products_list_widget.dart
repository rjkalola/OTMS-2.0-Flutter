import 'package:belcka/pages/user_orders/favorite_popup/add_folder_view.dart';
import 'package:belcka/pages/user_orders/favorite_popup/favorite_popup_manager.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/view/widgets/products_loading_skeleton.dart';
import 'package:belcka/pages/user_orders/widgets/icons/bookmark_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/app_colors.dart';
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

  final Map<int, int> currentImageIndex = {};
  final Set<int> _expandedProductIds = {};

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
                  padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
                  itemCount: controller.categories.length,
                  controller: controller.scrollController,
                  itemBuilder: (context, catIndex) {
                    final category = controller.categories[catIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        if (!category.continuedCategory)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
                              border: Border(left: BorderSide(color: defaultAccentColor_(context), width: 4),
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
                        const SizedBox(height: 12),

                        //Products UI
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
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
                                : ((product.cartQty ?? 0) -
                                    (product.qty ?? 0.0));
                            final packOfUnit = product.packOfUnit ?? "";
                            final projectService = Get.find<ProjectService>();
                            final LayerLink layerLink = LayerLink();
                            String availableQtyText =
                                "${((product.qty ?? 0.0).toInt())}";

                            double totalPrice = product.productSet?.fold(0.0, (sum, item) {
                              double price = double.tryParse(item.displayPrice ?? '0') ?? 0.0;
                              return sum! + price;
                            }) ?? 0.0;

                            String formattedPrice = totalPrice.toStringAsFixed(2);
                            bool isSetExpanded = _expandedProductIds.contains(product.productId ?? 0);

                            return GestureDetector(
                              onTap: () {
                                final currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  return;
                                }
                                var arguments = {
                                  "product_id": product.productId
                                };
                                controller.moveToScreen(
                                  AppRoutes.productDetailsScreen,
                                  arguments,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // TOP SECTION
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // IMAGE
                                          Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  color:
                                                      lightGreyColor(context),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: PageView.builder(
                                                  controller: pageController,
                                                  itemCount: product.productImages?.length ?? 0,
                                                  onPageChanged: (page) {
                                                    setState(() {
                                                      currentImageIndex[index] = page;
                                                    });
                                                  },
                                                  itemBuilder:
                                                      (context, imgIndex) {
                                                    return InkWell(
                                                      onTap: () {
                                                        ImageUtils.moveToImagePreview(product.productImages ?? [], imgIndex,
                                                        );
                                                      },
                                                      child: Image.network(product.productImages?[imgIndex].thumbUrl ?? "",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stack,
                                                        ) {
                                                          return Center(
                                                            child: Icon(Icons.photo_outlined, size: 45, color: Colors.grey.shade300,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                child: Row(
                                                  children: List.generate(
                                                    product.productImages?.length ?? 0,
                                                    (dotIndex) {
                                                      final isActive = (currentImageIndex[index] ?? 0) == dotIndex;
                                                      return AnimatedContainer(
                                                        duration: const Duration(milliseconds: 250),
                                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                                        width: isActive ? 12 : 5,
                                                        height: 5,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                                          color: isActive ? defaultAccentColor_(context)
                                                              : Colors.white,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(width: 10),

                                          // DETAILS
                                          Expanded(
                                            child: SizedBox(
                                              height: 135,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // TITLE
                                                  TitleTextView(
                                                    text: product.shortName ?? "",
                                                    fontSize: 15,
                                                    maxLine: 2,
                                                    fontWeight: FontWeight.w600,
                                                  ),

                                                  const SizedBox(height: 4),

                                                  // SKU
                                                  SubtitleTextView(
                                                    text: product.uuid ?? "",
                                                    fontSize: 12,
                                                    color: secondaryExtraLightTextColor_(context),),

                                                  const SizedBox(height: 8),
                                                  // DESCRIPTION
                                                  Expanded(
                                                    child: Text(
                                                      product.description ?? "",
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        height: 1.4,
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                  ),
                                                  // QTY + PRICE
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Qty: $availableQtyText",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      TitleTextView(
                                                        text:
                                                            "${product.currency}${product.displayPrice ?? ""}",
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Divider(
                                      color: dividerColor_(context),
                                      height: 1,
                                    ),

                                    // ACTIONS
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          // SET AVAILABLE
                                          if (isInSet)
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (isSetExpanded) {
                                                    _expandedProductIds.remove(product.productId ?? 0);
                                                  }
                                                  else{
                                                    _expandedProductIds.add(product.productId ?? 0);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: defaultAccentColor_(context),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text("Set Available",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                     Icon(
                                                      isSetExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          const Spacer(),

                                          // BOOKMARK
                                          Builder(
                                            builder: (buttonContext) {
                                              bool isBookmarked = product.isBookMark ?? false;
                                              return InkWell(
                                                onTap: () {
                                                  if (isBookmarked) {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    controller.toggleBookmark(
                                                      index, category, product.folderId ?? 0,
                                                    );
                                                    product.isBookMark = false;
                                                    controller.categories.refresh();
                                                  }
                                                  else{
                                                    if (projectService
                                                        .folderList.isEmpty) {
                                                      showDialog(
                                                        context: buttonContext,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            backgroundColor: Colors.transparent,
                                                            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                                                            child: Container(
                                                              padding: const EdgeInsets.all(20),
                                                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child: AddFolderView(
                                                                folders: [],
                                                                onCancel: () =>
                                                                    Navigator.pop(context),
                                                                onAdded: (folderName, projectId) async {
                                                                  Navigator.pop(context);
                                                                  final newFolder = await projectService.toggleCreateNewFolder(folderName, projectId);
                                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                                  controller.toggleBookmark(index, category, newFolder?.id ?? 0,);
                                                                  product.isBookMark = true;
                                                                  controller.categories.refresh();
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                    else{
                                                      FavoritePopupManager.show(
                                                        context: buttonContext,
                                                        layerLink: layerLink,
                                                        folders: projectService.folderList,
                                                        onProjectSelected:
                                                            (folder) {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          controller.toggleBookmark(index, category, folder.id ?? 0,);
                                                          product.isBookMark = true;
                                                          controller.categories.refresh();
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                                child:
                                                    CompositedTransformTarget(
                                                  link: layerLink,
                                                  child: Icon(
                                                    isBookmarked
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_border,
                                                    color: isBookmarked
                                                        ? Colors.orange
                                                        : Colors.black87,
                                                    size: 24,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          const SizedBox(width: 14),

                                          // ADD TO CART
                                          !isAdded ? PrimaryButton(
                                                  isFixSize: true,
                                                  width: 150,
                                                  height: 40,
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                  buttonText: "add_to_cart".tr,
                                                  onPressed: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    if (isAdded) {
                                                      controller.toggleRemoveCart(index, category,);
                                                    }
                                                    else{
                                                      controller.increaseQty(index, category,);
                                                      controller.toggleAddToCart(index, 1, category,
                                                      );
                                                    }
                                                  },
                                                )
                                              : ProductQuantityChangeWidget(
                                                  focusNode: product.qtyFocusNode,
                                                  isSubQuantity: isSubQuantity,
                                                  quantity: (product.cartQty ?? 0).toInt(),
                                                  unit: packOfUnit,
                                                  onChanged: (value,) {
                                                    controller.updateSubQty(index, value, category,);
                                                    controller.toggleAddToCart(index, value, category,);
                                                  },
                                                  onIncrease: () {
                                                    controller.increaseQty(index, category,);
                                                    final newQty = (category.products[index].cartQty ?? 0).toInt();
                                                    controller.toggleAddToCart(index, newQty, category,);
                                                  },
                                                  onDecrease: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    controller.decrementOrRemoveFromCart(index, category,);
                                                    },

                                          ),
                                        ],
                                      ),
                                    ),

                                    // SET PRODUCTS
                                    if (isInSet && isSetExpanded) ...[
                                      Divider(
                                        color: dividerColor_(context),
                                        height: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 110,
                                              child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: product.productSet?.length ?? 0,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(width: 20),
                                                itemBuilder: (context, setIndex,) {
                                                  final setItem =  product.productSet?[setIndex];
                                                  return Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(width: 90, height: 70, clipBehavior: Clip.antiAlias,
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),),
                                                            child: Image.network(setItem?.thumbUrl ?? "",
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (context, error, stack,
                                                                  ) {
                                                                return Center(
                                                                  child: Icon(Icons.photo_outlined, size: 45, color: Colors.grey.shade300,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(height: 8),
                                                          SizedBox(width: 110,
                                                            child:
                                                            Text(setItem?.productName ?? "",
                                                              textAlign: TextAlign.center,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(fontSize: 13,),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (setIndex != (product.productSet?.length ?? 0) - 1)
                                                        const Padding(padding: EdgeInsets.symmetric(horizontal: 4),
                                                          child: Text("+",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: AppColors.primaryTextColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),

                                            // ADD SET TO CART
                                            GestureDetector(
                                              onTap:(){
                                                if (product.productSet?.isNotEmpty ?? false){
                                                  List<Map<String, dynamic>> productDataList = (product.productSet!.map((item) {
                                                    return {
                                                      "product_id": item.productId,
                                                      "qty": item.qty,
                                                      "cart_qty": 1,
                                                      "is_sub_qty": (item.isSubQty ?? false) ? 1 : 0,
                                                      "price": item.displayPrice,
                                                    };
                                                  }
                                                  ).toList());
                                                  controller.addSetProductsToCart(product.productId ?? 0, productDataList,index,category);
                                                }
                                              },
                                              child: Container(
                                                width: 250,
                                                height: 36,
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30),),
                                                alignment: Alignment.center,
                                                child:
                                                Text("Add set to cart: ${product.currency}$formattedPrice",
                                                  style: TextStyle(color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    // OUT OF STOCK
                                    if (isAdded)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: OutOfStockBanner(
                                          itemCount: (outOfStockCount).toInt(),
                                          deliveryDays: 5,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
          ),
    )
    );
  }
}
