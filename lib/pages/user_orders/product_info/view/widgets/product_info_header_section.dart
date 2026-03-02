import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInfoHeaderSection extends StatefulWidget {
  const ProductInfoHeaderSection({super.key});

  @override
  State<ProductInfoHeaderSection> createState() =>
      _ProductInfoHeaderSectiontState();
}

class _ProductInfoHeaderSectiontState extends State<ProductInfoHeaderSection> {

  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                            Icons.photo_outlined,
                            size: 50,
                            color: Colors.grey.shade300,
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
              const SizedBox(height: 4),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TitleTextView(
                  text: controller.product.value.shortName ?? "",
                  fontSize: 15,
                  maxLine: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(icon:
              controller.product.value.isBookMark ?? true ? Icon(Icons.bookmark) :
              Icon(Icons.bookmark_outline),
                  color: controller.product.value.isBookMark ?? true ?
                  Colors.deepOrangeAccent : primaryTextColor_(context),
                  iconSize: 30,
                  onPressed: () {
                    controller.toggleBookmark();
                  })
            ],
          ),
        ),
      ],
    ));
  }
}