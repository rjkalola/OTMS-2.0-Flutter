import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:belcka/pages/user_orders/favorite_popup/add_folder_view.dart';
import 'package:belcka/pages/user_orders/favorite_popup/favorite_popup_manager.dart';
import 'package:belcka/pages/user_orders/product_details/controller/product_details_controller.dart';
import 'package:belcka/pages/user_orders/project_service/project_service.dart';
import 'package:belcka/pages/user_orders/widgets/icons/bookmark_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/icons/cart_icon_widget.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_change_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({super.key});

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return Obx(() {
      final product = controller.product.value;
      final isSubQuantity = product.isSubQty ?? false;
      final isAdded = product.isCartProduct ?? false;
      final isInSet = product.isInSet ?? false;
      final outOfStockCount = isSubQuantity
          ? ((product.cartQty ?? 0) -
              (int.tryParse(product.packOffQty ?? "0") ?? 0))
          : ((product.cartQty ?? 0) - (product.qty ?? 0.0));
      final packOfUnitName = product.packOfUnitName ?? "";
      final packOfUnit = product.packOfUnit ?? "";
      String availableQtyText = "${((product.qty ?? 0.0).toInt())}";
      final projectService = Get.find<ProjectService>();
      final LayerLink _layerLink = LayerLink();

      return Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Product Image Card
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    // Increased height significantly to give the image more room to breathe
                    height: 300,
                    decoration: BoxDecoration(
                      color: lightGreyColor(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CardViewDashboardItem(
                      margin: EdgeInsets.zero,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: product.productImages?.length ?? 0,
                        onPageChanged: (page) {
                          controller.setCurrentImageIndex(0, page);
                        },
                        itemBuilder: (context, imgIndex) {
                          return InkWell(
                            onTap: () {
                              ImageUtils.moveToImagePreview(
                                  product.productImages ?? [], imgIndex);
                            },
                            // Center ensures the image stays in the middle if it's smaller than the box
                            child: Center(
                              child: Image.network(
                                product.productImages?[imgIndex].thumbUrl ?? "",
                                // 'contain' ensures the FULL image is visible without cropping.
                                // If you want it to fill the width completely, use 'fitWidth'.
                                fit: BoxFit.contain,
                                // This removes the "small" look by telling the image to
                                // be as large as possible within the 300 height limit.
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stack) {
                                  return Center(
                                    child: Icon(
                                      Icons.photo_outlined,
                                      color: Colors.grey.shade300,
                                      size: 60,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // PageView Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      product.productImages?.length ?? 0,
                      (dotIndex) {
                        final isActive =
                            (controller.currentImageIndex[0] ?? 0) == dotIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isActive ? 8 : 6,
                          height: isActive ? 8 : 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
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

              const SizedBox(height: 16),
              // Product Details
              TitleTextView(
                text: product.shortName ?? "",
                fontSize: 15,
                maxLine: 2,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  TitleTextView(
                    text: "${product.supplierName ?? ""}: ",
                    color: primaryTextColor_(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  SubtitleTextView(
                    text: product.supplierCode ?? "",
                    color: secondaryExtraLightTextColor_(context),
                    fontSize: 13,
                  ),
                ],
              ),
              Row(
                children: [
                  TitleTextView(
                    text: "${'product_code'.tr}: ",
                    color: primaryTextColor_(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  SubtitleTextView(
                    text: product.uuid ?? "",
                    color: secondaryExtraLightTextColor_(context),
                    fontSize: 13,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextView(
                          text:
                              "${product.currency ?? ""}${product.marketPrice ?? ""}",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          children: [
                            TitleTextView(
                              text: "${'available_qty'.tr}: $availableQtyText",
                              fontSize: 14,
                              color: secondaryExtraLightTextColor_(context),
                            ),
                            SizedBox(width: 8,),
                            //Favorite
                            Visibility(
                              visible: !controller.isReadOnly.value,
                              child: InkWell(
                                onTap: (){
                                  if (projectService.folderList.isEmpty) {
                                    showDialog(
                                      context: context,
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
                                              onAdded: (folderName,projectId) async {
                                                Navigator.pop(context);
                                                final newFolder = await projectService.toggleCreateNewFolder(folderName,projectId);

                                                print("New Folder ID: ${newFolder?.id ?? 0}");

                                                FocusManager.instance.primaryFocus?.unfocus();
                                                controller.toggleBookmark(newFolder?.id ?? 0);
                                                controller.product.value.isBookMark =
                                                !(controller.product.value.isBookMark ??
                                                    false);
                                                controller.product.refresh();

                                              },

                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  else{
                                    FavoritePopupManager.show(
                                      context: context,
                                      layerLink: _layerLink,
                                      folders: projectService.folderList,
                                      onProjectSelected: (project) {
                                        print("Selected: ${project.name ?? ""}");
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        controller.toggleBookmark(project.id ?? 0);
                                        controller.product.value.isBookMark =
                                        !(controller.product.value.isBookMark ??
                                            false);
                                        controller.product.refresh();
                                      },
                                    );
                                  }

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
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 8,),
                        Divider(
                          color: dividerColor_(context),
                        ),
                        Visibility(
                          visible: !controller.isReadOnly.value,
                          child: Row(
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
                                              defaultAccentColor_(context)),
                                      child: Text('add_set'.tr),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    )
                                  ],
                                ),

                              // if (isAdded) ...[
                              //   ProductQuantityChangeWidget(
                              //     focusNode: product.qtyFocusNode,
                              //     isSubQuantity: isSubQuantity,
                              //     quantity: (product.cartQty ?? 0).toInt(),
                              //     unit: packOfUnit,
                              //     onChanged: (value) {
                              //       controller.updateSubQty(value);
                              //       controller.toggleAddToCart(value);
                              //     },
                              //     onIncrease: () {
                              //       controller.increaseQty();
                              //     },
                              //     onDecrease: () {
                              //       controller.decrementOrRemoveFromCart();
                              //     },
                              //   ),
                              //   const SizedBox(width: 8),
                              // ],
                              Spacer(),

                              // if (isAdded)
                              //   GestureDetector(
                              //     onTap: (){
                              //       FocusManager.instance.primaryFocus?.unfocus();
                              //       controller.toggleRemoveCart();
                              //     },
                              //     child: Container(
                              //       padding: const EdgeInsets.all(6),
                              //       decoration: BoxDecoration(
                              //         color: Colors.redAccent.shade200,
                              //         borderRadius: BorderRadius.circular(6),
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
                              // ElevatedButton.icon(
                              //   style: ElevatedButton.styleFrom(
                              //     minimumSize: const Size(0, 34),
                              //     backgroundColor: isAdded
                              //         ? Colors.redAccent.shade200
                              //         : Colors.green,
                              //     foregroundColor: Colors.white,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 0, horizontal: 12),
                              //   ),
                              //   onPressed: () {
                              //     FocusManager.instance.primaryFocus?.unfocus();
                              //     if (isAdded) {
                              //       controller.toggleRemoveCart();
                              //     } else {
                              //       if ((product.cartQty ?? 0) > 0) {
                              //         controller.toggleAddToCart(
                              //             (product.cartQty ?? 0).toInt());
                              //       } else {
                              //         controller.increaseQty();
                              //       }
                              //     }
                              //   },
                              //   icon: isAdded
                              //       ? ImageUtils.setSvgAssetsImage(
                              //           path: Drawable.deleteIcon,
                              //           width: 18,
                              //           height: 18,
                              //           color: Colors.white,
                              //         )
                              //       : CartIconWidget(
                              //           color: Colors.white,
                              //           size: 16,
                              //         ),
                              //   label: Text(
                              //     isAdded ? "remove".tr : "add_to_cart".tr,
                              //     style: const TextStyle(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.w400,
                              //       fontSize: 14,
                              //     ),
                              //   ),
                              // ),

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
                                          controller.toggleRemoveCart();
                                        } else {
                                          if ((product.cartQty ?? 0) > 0) {
                                            controller.toggleAddToCart(
                                                (product.cartQty ?? 0).toInt());
                                          } else {
                                            controller.increaseQty();
                                          }
                                        }
                                      })
                                  : ProductQuantityChangeWidget(
                                      focusNode: product.qtyFocusNode,
                                      isSubQuantity: isSubQuantity,
                                      quantity: (product.cartQty ?? 0).toInt(),
                                      unit: packOfUnit,
                                      onChanged: (value) {
                                        controller.updateSubQty(value);
                                        controller.toggleAddToCart(value);
                                      },
                                      onIncrease: () {
                                        controller.increaseQty();
                                      },
                                      onDecrease: () {
                                        controller.decrementOrRemoveFromCart();
                                      },
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // OUT OF STOCK MESSAGE
              if (product.isCartProduct ?? false)
                OutOfStockBanner(
                  itemCount: (outOfStockCount).toInt(),
                  deliveryDays: 5,
                ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  var arguments = {"product_id": product.productId};
                  controller.moveToScreen(
                      AppRoutes.productSetScreen, arguments);
                },
                child: NavigationCard(
                  value: "product_set".tr,
                  isShowArrow: true,
                ),
              ),

              GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var arguments = {"product_id": product.productId};
                    controller.moveToScreen(
                        AppRoutes.productInfoScreen, arguments);
                  },
                  child: NavigationCard(
                    value: "product_info".tr,
                    isShowArrow: true,
                  )),

              NavigationCard(
                value: "technical_specification".tr,
                isShowArrow: true,
              ),
            ],
          ),
        ),
      );
    });
  }
}
