import 'package:belcka/pages/user_orders/widgets/product_quantity_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_controller.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/view/widgets/order_details_editable_notes_field.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternalOrderDetailsListWithQuantity extends StatefulWidget {
  const InternalOrderDetailsListWithQuantity({super.key,
  });

  @override
  State<InternalOrderDetailsListWithQuantity> createState() =>
      _InternalOrderDetailsListWithQuantityState();
}

class _InternalOrderDetailsListWithQuantityState extends State<InternalOrderDetailsListWithQuantity> {

  final controller = Get.put(StoremanInternalOrderDetailsController());

  @override
  Widget build(BuildContext context) {

    final orderInfo = controller.orderDetails[0];
    final orders = orderInfo.orders ?? [];

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = orders[index];
        final isSubQuantity = item.isSubQty ?? false;
        final packOfUnit = item.packOfUnit ?? "";

        final deliveredQty = (double.tryParse(item.deliveredQty ?? "") ?? 0.00);
        final subQty = (double.tryParse(item.subQty ?? "") ?? 0.00);
        final qty = (double.tryParse(item.qty ?? "") ?? 0.00);

        //final remainingQty = (isSubQuantity ? (subQty - deliveredQty) : (qty - deliveredQty)).toInt();
        final remainingQty = (double.tryParse(item.remainingQty ?? "") ?? 0.00);
        final isItemDelivered = (item.status  == AppConstants.internalOrderStatus.delivered) ? true : false;
        final isQuantityChanged = item.isQuantityChanged || (item.note ?? "").isNotEmpty;

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: CardViewDashboardItem(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isItemDelivered)
                        CustomCheckbox(
                            onValueChange: (value) {
                              setState(() {
                                orders[index].isSelected = !(orders[index].isSelected);
                                controller.orderDetails.refresh();
                              });
                            },
                            mValue: orders[index].isSelected),
                        const SizedBox(width: 4),
                        ImageUtils.setRectangleCornerCachedNetworkImage(
                          url: orders[index].productThumbImage ?? "",
                          width: 90,
                          height: 90,
                          borderRadius: 4,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextView(
                                text: orders[index].shortName ?? "",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 8),
                              SubtitleTextView(
                                text: orders[index].uuid ?? "",
                              ),
                              const SizedBox(height: 4),
                              TitleTextView(
                                text: "${'price'.tr}: ${orders[index].currency ?? "£"}"
                                    "${(orders[index].marketPrice ?? "0.00")}",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 4),
                              TitleTextView(
                                text: "${'total'.tr}: ${orders[index].currency ?? "£"}"
                                    "${(orders[index].product?.totalAmount ?? "0.00")}",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 8),
                              if (!isItemDelivered)
                              ProductQuantityWidget(
                                focusNode: controller.qtyFocusNodes[index],
                                isSubQuantity: isSubQuantity,
                                quantity: remainingQty.toInt(),
                                unit: packOfUnit,
                                onChanged: (value) {
                                  String newValue = "$value";
                                  if (newValue.isEmpty) return;
                                  int? newCount = int.tryParse(newValue);
                                  setState(() {
                                    if (newCount == null || newCount <= 0) {
                                      item.remainingQty = "1";
                                      item.isQuantityChanged = true;
                                      controller.updateSubQty(index, 1);
                                    }
                                    else{
                                      controller.updateSubQty(index, newCount);
                                    }
                                  });
                                },
                                onIncrease: () {
                                  setState(() {
                                    controller.increaseQty(index);
                                  });
                                },
                                onDecrease: () {
                                  setState(() {
                                    controller.decreaseQty(index);
                                  });
                                },
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isQuantityChanged)
                    SizedBox(height: 16,),
                    // Editable Notes Field
                    if (isQuantityChanged)

                      /*
                    OrderDetailsEditableNotesField(value: orders[index].note ?? "", onChanged: (val){
                      setState(() {
                        orders[index].note = val;
                      });
                    },enabled: !isItemDelivered,),
                    */

                      OrderDetailsEditableNotesField(
                        enabled: !isItemDelivered,
                        value: item.note ?? "",
                        attachmentCount: 0,
                        borderColor: (item.isQuantityChanged && (item.note?.isEmpty ?? true))
                            ? Colors.red
                            : Colors.grey.shade400,
                        onChanged: (val) {
                          setState(() {
                            orders[index].note = val;
                          });
                        },
                        onAttachmentTap: () {
                          // Call your ImagePicker logic here
                          //pickImages(index);
                        },
                      ),

                    if (isItemDelivered)
                      Column(
                        children: [
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              TitleTextView(
                                text: "Ordered Qty: ${isSubQuantity ? "${subQty.toInt()} $packOfUnit" : qty.toInt()}",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              Spacer(),
                              TitleTextView(
                                text: "Delivered Qty: ${isSubQuantity ? "${deliveredQty.toInt()} $packOfUnit" : deliveredQty.toInt()}",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
