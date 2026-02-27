import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_buyer_order_controller.dart';

class BuyerCreateOrderFooterView extends StatelessWidget {
  BuyerCreateOrderFooterView({super.key});

  final controller = Get.put(CreateBuyerOrderController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Divider(
            thickness: 0.6,
          ),
          Padding(
            padding:
                EdgeInsetsGeometry.only(left: 20, right: 20, top: 6, bottom: 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTextView(
                      text: 'unite_total'.tr,
                    ),
                    TitleTextView(
                      text:
                          "${controller.currency}${controller.uniteTotal.value}",
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTextView(
                      text: "${'tax'.tr} (20%)",
                    ),
                    TitleTextView(
                      text:
                          "${controller.currency}${controller.uniteTotal.value * 0.2}",
                    ),
                  ],
                ),
                Divider(
                  color: dividerColor_(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTextView(
                      text: 'total_amount'.tr,
                      fontWeight: FontWeight.w500,
                    ),
                    TitleTextView(
                      text:
                          "${controller.currency}${controller.uniteTotal.value * 1.2}",
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(5, 14, 20, 0),
          //   child: Row(
          //     children: [
          //       CustomCheckbox(
          //           onValueChange: (isCheck) {
          //             controller.isCheckedProduct.value = isCheck ?? false;
          //           },
          //           mValue: controller.isCheckedProduct.value),
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             controller.isCheckedProduct.value =
          //                 !controller.isCheckedProduct.value;
          //           },
          //           child: TitleTextView(
          //             text: 'crete_buyer_order_checkbox_note'.tr,
          //             softWrap: true,
          //             fontSize: 15,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: PrimaryButton(
                      buttonText: 'draft'.tr,
                      onPressed: () {
                        controller.onClickCreateOrder(true);
                      },
                      color: Colors.redAccent,
                    )),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: PrimaryButton(
                      buttonText: 'create_order'.tr,
                      onPressed: () {
                        controller.onClickCreateOrder(false);
                      },
                      color: Colors.green,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
