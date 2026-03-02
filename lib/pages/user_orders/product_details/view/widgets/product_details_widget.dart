import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:belcka/pages/user_orders/product_details/controller/product_details_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
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
    final outOfStockCount = controller.product.value.cartQty ?? 0 - (controller.product.value.qty ?? 0);

    return Obx(() => Expanded(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      itemCount: controller.product.value.productImages?.length ?? 0,
                      onPageChanged: (page) {
                        setState(() {
                          controller.currentImageIndex[0] = page;
                        });
                      },
                      itemBuilder: (context, imgIndex) {
                        return Image.network(
                          controller.product.value.productImages?[imgIndex].thumbUrl ?? "",
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
                  ///Book mark
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(icon:
                    controller.product.value.isBookMark ?? true ? Icon(Icons.bookmark) :
                    Icon(Icons.bookmark_outline),
                        color: controller.product.value.isBookMark ?? true ?
                        Colors.deepOrangeAccent : primaryTextColor_(context),
                        iconSize: 30,
                        onPressed: () {
                          controller.toggleBookmark();
                        })
                  ),
                  /// Dots Indicator
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: List.generate(
                        controller.product.value.productImages?.length ?? 0,
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
              text: controller.product.value.shortName ?? "",
              fontSize: 15,
              maxLine: 2,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8),

            Row(
              children: [
                TitleTextView(text: "${controller.product.value.supplierName ?? ""}: ",
                  color: primaryTextColor_(context),
                fontSize: 15,
                fontWeight: FontWeight.w500,),
                SubtitleTextView(text: controller.product.value.supplierCode ?? "",
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
                SubtitleTextView(text: controller.product.value.uuid ?? "",
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
                      text: "${controller.product.value.currency ?? ""}${controller.product.value.price ?? ""}",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),

                    SizedBox(height: 4),
                    TitleTextView(
                      text: "${'available_qty'.tr}: ${controller.product.value.qty}",
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
                        bool isAdded = controller.product.value.isCartProduct ?? false;
                        if (isAdded){
                          controller.toggleRemoveCart();
                        }
                        else{
                          if ((controller.product.value.cartQty ?? 0) > 0){
                            controller.toggleAddToCart();
                          }
                        }
                      },
                        icon: Icon(
                          (controller.product.value.isCartProduct ?? false)
                              ? Icons.shopping_bag_outlined
                              : Icons.shopping_cart_outlined,
                          color: (controller.product.value.isCartProduct ?? false) ? defaultAccentColor_(context) : Colors.green,
                        ),iconSize: 30,),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OrderQuantityChangeButton(
                              text: "-", onTap: (){
                            setState(() {
                              controller.decreaseQty();
                            });
                          }),
                          SizedBox(width: 8),
                          OrderQuantityDisplayTextView(
                            value: controller.product.value.cartQty ?? 0,
                            width: 52,
                            height: 30,
                          ),
                          SizedBox(width: 8),
                          OrderQuantityChangeButton(
                              text: "+", onTap: (){
                            setState(() {
                              controller.increaseQty();
                            });
                          }),
                          SizedBox(width: 8),
                        ],
                      ),
                      SizedBox(height: 8,),
                      /*
                      OrdersTitleTextView(
                       text:'Qty: 1',
                          fontSize: 15
                      ),
                      */
                    ],
                  ),
                )

              ],
            ),

            // OUT OF STOCK MESSAGE
            if ((controller.product.value.qty ?? 0) >= 0 && (controller.product.value.isCartProduct ?? false))
              OutOfStockBanner(
                itemCount: outOfStockCount,
                deliveryDays: 5,
              ),

            SizedBox(height: 20),

            InkWell(
              onTap: (){

              },
                child: NavigationCard(value: "product_set".tr,isShowArrow: true,)),

            InkWell(
              onTap: (){
                var arguments = {
                  "product_id":controller.product.value.productId
                };
                controller.moveToScreen(AppRoutes.productInfoScreen, arguments);
              },
                child: NavigationCard(value: "product_info".tr,isShowArrow: true,)),

            NavigationCard(value: "technical_specification".tr,isShowArrow: true,),
          ],
        ),
      ),
    ));
  }
}