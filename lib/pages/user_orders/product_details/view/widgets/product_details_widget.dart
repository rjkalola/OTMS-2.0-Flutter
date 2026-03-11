import 'package:belcka/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:belcka/pages/user_orders/product_details/controller/product_details_controller.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
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
      final outOfStockCount = isSubQuantity ? ((product.cartQty ?? 0) - (int.parse(product.packOffQty ?? "")))
          : ((product.cartQty ?? 0) - (product.qty ?? 0.0));
      final packOfUnitName = product.packOfUnitName ?? "";
      final packOfUnit = product.packOfUnit ?? "";
      String availableQtyText = "${((product.qty ?? 0.0).toInt())}";

      return Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Product Image Card
              SizedBox(
                width: double.infinity,
                height: 260,
                child: Stack(
                  children: [
                    CardViewDashboardItem(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: product.productImages?.length ?? 0,
                        onPageChanged: (page) {
                          setState(() {
                            controller.currentImageIndex[0] = page;
                          });
                        },
                        itemBuilder: (context, imgIndex) {
                          return Image.network(
                            product.productImages?[imgIndex].thumbUrl ?? "",
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stack) {
                              return  Center(
                                child: Icon(
                                  Icons
                                      .photo_outlined,
                                  color: Colors.grey.shade300,
                                  size: 50,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(icon:
                        product.isBookMark ?? true ? Icon(Icons.bookmark) :
                        Icon(Icons.bookmark_outline),
                            color: product.isBookMark ?? true ?
                            Colors.deepOrangeAccent : primaryTextColor_(context),
                            iconSize: 30,
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              controller.toggleBookmark();
                            })
                    ),

                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: List.generate(
                          product.productImages?.length ?? 0,
                              (dotIndex) {
                            final isActive =
                                (controller.currentImageIndex[0] ??
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
                                    ? defaultAccentColor_(context)
                                    : Colors.grey[500],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                  TitleTextView(text: "${product.supplierName ?? ""}: ",
                    color: primaryTextColor_(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,),
                  SubtitleTextView(text: product.supplierCode ?? "",
                    color: secondaryExtraLightTextColor_(context),
                    fontSize: 13,
                  ),
                ],
              ),
              Row(
                children: [
                  TitleTextView(text:"${'product_code'.tr}: ",
                    color: primaryTextColor_(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,),
                  SubtitleTextView(text: product.uuid ?? "",
                    color: secondaryExtraLightTextColor_(context),
                    fontSize: 13,),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextView(
                        text: "${product.currency ?? ""}${product.price ?? ""}",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),

                      SizedBox(height: 4),
                      TitleTextView(
                        text: "${'available_qty'.tr}: $availableQtyText",
                        fontSize: 13,
                        color: secondaryExtraLightTextColor_(context),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){
                          FocusManager.instance.primaryFocus?.unfocus();
                          bool isAdded = product.isCartProduct ?? false;
                          if (isAdded){
                            controller.toggleRemoveCart();
                          }
                          else{
                            if (isSubQuantity){
                              if ((int.parse(product.packOffQty ?? "")) > 0){
                                controller.toggleAddToCart((int.parse(product.packOffQty ?? "") ?? 0));
                              }
                            }
                            else{
                              if ((product.cartQty ?? 0) > 0){
                                controller.toggleAddToCart((product.cartQty ?? 0).toInt());
                              }
                            }
                          }
                        },
                          icon: Icon(
                            (product.isCartProduct ?? false)
                                ? Icons.shopping_bag_outlined
                                : Icons.shopping_cart_outlined,
                            color: (product.isCartProduct ?? false) ? defaultAccentColor_(context) : Colors.green,
                          ),iconSize: 30,),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ProductQuantityWidget(
                              isSubQuantity: isSubQuantity,
                              quantity: isSubQuantity
                                  ? (isAdded
                                  ? (product.cartQty ?? 0).toInt()
                                  : int.tryParse(product.packOffQty ?? "") ?? 0)
                                  : (product.cartQty ?? 0).toInt(),
                              unit: packOfUnit,
                              onChanged: (value) {
                                controller.updateSubQty(value);
                              },
                              onIncrease: () {
                                setState(() {
                                  controller.increaseQty();
                                });
                              },
                              onDecrease: () {
                                setState(() {
                                  controller.decreaseQty();
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),

                      ],
                    ),
                  )

                ],
              ),

              // OUT OF STOCK MESSAGE
              if (product.isCartProduct ?? false)
                OutOfStockBanner(
                  itemCount: (outOfStockCount).toInt(),
                  deliveryDays: 5,
                ),

              SizedBox(height: 20),
              NavigationCard(value: "product_set".tr,isShowArrow: true,),

              InkWell(
                  onTap: (){
                    FocusManager.instance.primaryFocus?.unfocus();
                    var arguments = {
                      "product_id":product.productId
                    };
                    controller.moveToScreen(AppRoutes.productInfoScreen, arguments);
                  },
                  child: NavigationCard(value: "product_info".tr,isShowArrow: true,)),

              NavigationCard(value: "technical_specification".tr,isShowArrow: true,),
            ],
          ),
        ),
      );
    });
  }
}