import 'package:belcka/pages/user_orders/product_set/controller/product_set_controller.dart';
import 'package:belcka/pages/user_orders/widgets/out_of_stock_banner.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/user_orders/widgets/product_quantity_widget.dart';
import 'package:belcka/res/drawable.dart';


class ProductSetItemList extends StatefulWidget {
  const ProductSetItemList({super.key});
  @override
  State<ProductSetItemList> createState() => _ProductSetItemListState();
}

class _ProductSetItemListState extends State<ProductSetItemList>{

  final controller = Get.put(ProductSetController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.productsSet.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
      ),
      itemBuilder: (context, index) {
        final product = controller.productsSet[index];
        final isAdded = product.isCartProduct ?? false;
        final isSubQuantity = product.isSubQty ?? false;
        final outOfStockCount = isSubQuantity
            ? ((product.cartQty ?? 0) -
            (int.parse(product.packOffQty ?? "0")))
            : ((product.cartQty ?? 0) - (product.qty ?? 0.0));

        final packOfUnit = product.packOfUnit ?? "";
        String availableQtyText = "${((product.qty ?? 0.0).toInt())}";

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUtils.setRectangleCornerCachedNetworkImage(
                    url: product.thumbUrl ?? "",
                    width: 80,
                    height: 80,
                    borderRadius: 6,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.shortName ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            InkWell(
                                onTap: (){
                                  FocusManager.instance.primaryFocus
                                      ?.unfocus();
                                  controller.toggleBookmark(index);
                                  product.isBookMark = !(product.isBookMark??false);
                                  controller.productsSet.refresh();
                                },
                                child: Icon(product.isBookMark ?? true ? Icons.bookmark : Icons.bookmark_border,
                                  size: 20, color: product.isBookMark ?? true
                                      ? Colors.deepOrangeAccent
                                      : primaryTextColor_(context),)),
                          ],
                        ),

                        const SizedBox(height: 4),

                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${product.supplierName ?? ""}: ",
                                style: TextStyle(
                                  color: primaryTextColor_(context),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: product.uuid ?? "",
                                style: TextStyle(
                                  color: secondaryExtraLightTextColor_(context),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${product.currency ?? ""}${product.marketPrice ?? ""}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${'available_qty'.tr}: $availableQtyText",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),

                            if (!isAdded)

                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    controller.increaseQty(index);
                                    controller.toggleAddToCart(index, 1);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    isAdded ? Icons.delete_outline : Icons.shopping_cart_outlined,
                                    color: isAdded ? Colors.red : Colors.green,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 4),

                      ],
                    ),
                  ),
                ],
              ),

              if (isAdded)
                Divider(
                  color: dividerColor_(context),
                ),
              if (isAdded)
                Row(
                  children: [
                    if (isAdded) ...[
                      ProductQuantityWidget(
                        focusNode: controller.qtyFocusNodes[index],
                        isSubQuantity: isSubQuantity,
                        quantity: (product.cartQty ?? 0).toInt(),
                        unit: packOfUnit,
                        onChanged: (value) {
                          setState(() {
                            controller.updateSubQty(index, value);
                            controller.toggleAddToCart(index, value);
                          });
                        },
                        onIncrease: () {
                          setState(() {
                            controller.increaseQty(index);
                            final newQty =
                            (controller.productsSet[index].cartQty ?? 0)
                                .toInt();
                            controller.toggleAddToCart(index, newQty);
                          });
                        },
                        onDecrease: () {
                          setState(() {
                            final product = controller.productsSet[index];
                            final currentQty =
                            (product.cartQty ?? 0).toInt();
                            if (currentQty <= 1) return;
                            controller.decreaseQty(index);
                            final newQty =
                            (controller.productsSet[index].cartQty ?? 0)
                                .toInt();
                            controller.toggleAddToCart(index, newQty);
                          });

                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    Spacer(),
                    // REMOVE BUTTON
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          controller.toggleRemoveCart(index);
                        });

                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ImageUtils.setSvgAssetsImage(
                          path: Drawable.deleteIcon,
                          width: 18,
                          height: 18,
                          color: Colors.white,
                        ),
                      ),
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
        );
      },
    ));
  }
}
