import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_text_field.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
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
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          final pageController = PageController();

          return CardViewDashboardItem(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Carousel
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: product.images.length,
                            onPageChanged: (page) {
                              setState(() {
                                controller.currentImageIndex[index] = page;
                              });
                            },
                            itemBuilder: (context, imgIndex) {
                              return Image.network(
                                product.images[imgIndex],
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
                            product.images.length,
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
                                      ? Colors.blue
                                      : Colors.grey[400],
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
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.code,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "£${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Qty: ${product.qty}",
                          style: const TextStyle(
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 8),

                        // Quantity Selector
                        Row(
                          children: [
                            OrderQuantityChangeButton(
                                text: "-", onTap: (){}),
                            SizedBox(width: 8),

                            /*
                            OrderQuantityTextField(value:10,
                              onChanged: widget.onQtyTyped,
                              max: widget.item.availableQty,
                              maxLength: 3,
                            ),
                            */

                            OrdersTitleTextView(text:"2",),

                            SizedBox(width: 8),
                            OrderQuantityChangeButton(
                                text: "+", onTap: (){}),
                            SizedBox(width: 8),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add_shopping_cart_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Add to cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}