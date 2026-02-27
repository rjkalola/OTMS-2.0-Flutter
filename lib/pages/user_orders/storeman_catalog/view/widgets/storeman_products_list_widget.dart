import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_text_field.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanProductsListWidget extends StatefulWidget {
  const StoremanProductsListWidget({super.key});

  @override
  State<StoremanProductsListWidget> createState() =>
      _StoremanProductsListWidgetState();
}

class _StoremanProductsListWidgetState extends State<StoremanProductsListWidget> {

  final controller = Get.put(StoremanCatalogController());

  @override
  Widget build(BuildContext context) {
    return Obx(
            () => Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          final pageController = PageController();
          final isAdded = product.isCartProduct ?? false;
          final outOfStockCount = product.cartQty ?? 0 - (product.qty ?? 0);
          return InkWell(
            onTap: (){
              var arguments = {
                "product_id":product.productId
              };
              controller.moveToScreen(AppRoutes.productDetailsScreen, arguments);
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
                        // Product Image Carousel
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              Expanded(
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: product.productImages?.length ?? 0,
                                  onPageChanged: (page) {
                                    setState(() {
                                      controller.currentImageIndex[index] = page;
                                    });
                                  },
                                  itemBuilder: (context, imgIndex) {
                                    return Image.network(
                                      product.productImages?[imgIndex].thumbUrl ?? "",
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
                              const SizedBox(height: 4),
                              // PageView Dots
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: List.generate(
                                  product.productImages?.length ?? 0,
                                      (dotIndex) {
                                    final isActive =
                                        (controller.currentImageIndex[index] ??
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
                              const SizedBox(height: 4),
                            ],
                          ),
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
                                    child: Text(
                                      product.shortName ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.uuid ?? "",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${product.currency ?? ""}${product.price ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Available Qty: ${product.qty}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),

                              // Quantity Selector
                              Row(
                                children: [
                                  OrderQuantityChangeButton(
                                      text: "-", onTap: (){
                                    setState(() {
                                      controller.decreaseQty(index);
                                    });

                                  }),
                                  SizedBox(width: 8),
                                  OrdersTitleTextView(text: "${product.cartQty ?? 0}",),
                                  SizedBox(width: 8),
                                  OrderQuantityChangeButton(
                                      text: "+", onTap: (){
                                    setState(() {
                                      controller.increaseQty(index);
                                    });
                                  }),
                                  SizedBox(width: 8),
                                ],
                              ),

                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  IconButton(icon:
                                  product.isBookMark ?? true ? Icon(Icons.bookmark) :
                                  Icon(Icons.bookmark_outline,size: 30,),
                                      color: product.isBookMark ?? true ?
                                      Colors.deepOrangeAccent : primaryTextColor_(context),
                                      onPressed: () {
                                        controller.toggleBookmark(index);
                                      }),
                                  // Add to Cart Button
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          (isAdded) ? defaultAccentColor_(context) : Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                        ),
                                        onPressed: () {
                                          if (isAdded){
                                            controller.toggleRemoveCart(index);
                                          }
                                          else{
                                            if ((product.cartQty ?? 0) > 0){
                                              controller.toggleAddToCart(index);
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          (isAdded)
                                              ? Icons.check_circle_outline
                                              : Icons.add_shopping_cart_outlined,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          (isAdded) ? "Added" : "Add to cart",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // OUT OF STOCK MESSAGE
                    if ((product.qty ?? 0) >= 0 && isAdded)
                      OutOfStockBanner(
                        itemCount: outOfStockCount,
                        deliveryDays: 5,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}

