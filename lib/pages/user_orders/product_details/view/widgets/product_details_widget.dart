import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:belcka/pages/user_orders/product_details/controller/product_details_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
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
                            return const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_rounded,
                                color: Colors.grey,
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
            OrdersTitleTextView(
              text:controller.product.value.shortName ?? "",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8),

            Row(
              children: [
                OrdersTitleTextView(text: "${controller.product.value.supplierName ?? ""}: ",
                  color: primaryTextColor_(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,),
                OrdersTitleTextView(text: controller.product.value.supplierCode ?? "",
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  ),
              ],
            ),
            Row(
              children: [
                OrdersTitleTextView(text:"Product code: ",
                  color: primaryTextColor_(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,),
                OrdersTitleTextView(text: controller.product.value.uuid ?? "",
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 15,),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrdersTitleTextView(
                      text: "${controller.product.value.currency ?? ""}${controller.product.value.price ?? ""}",
                      fontWeight:FontWeight.bold ,
                      fontSize: 20,
                    ),
                    SizedBox(height: 4),
                    OrdersTitleTextView(text: "Available Qty: ${controller.product.value.qty}",),
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
                          OrdersTitleTextView(text: "${controller.product.value.cartQty ?? 0}",),
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
            NavigationCard(value: "Product Set".tr,isShowArrow: true,),
            NavigationCard(value: "Product Information".tr,isShowArrow: true,),
            NavigationCard(value: "Technical Specification".tr,isShowArrow: true,),
          ],
        ),
      ),
    ));
  }
}