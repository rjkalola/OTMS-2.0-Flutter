import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/order_details/controller/order_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrderDetailsOrdersList extends StatefulWidget {
  const OrderDetailsOrdersList({super.key,
  });

  @override
  State<OrderDetailsOrdersList> createState() => _OrderDetailsOrdersListState();
}

class _OrderDetailsOrdersListState extends State<OrderDetailsOrdersList> {

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {

    final orderInfo = controller.orderDetails[0];
    final orders = orderInfo.orders ?? [];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = orders[index];
        final isSubQuantity = item.isSubQty ?? false;
        final deliveredQty = (double.tryParse(item.deliveredQty ?? "") ?? 0.00);
        final subQty = (double.tryParse(item.subQty ?? "") ?? 0.00);
        final qty = (double.tryParse(item.qty ?? "") ?? 0.00);
        final isItemDelivered = (item.status  == AppConstants.internalOrderStatus.delivered) ? true : false;
        final packOfUnit = item.packOfUnit ?? "";
        bool isHaveAttachment = !StringHelper.isEmptyList(item.attachments);

        return CardViewDashboardItem(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if ((orders[index].status == AppConstants.internalOrderStatus.ready ||
                        orders[index].status == AppConstants.internalOrderStatus.preparing))

                    CustomCheckbox(
                        onValueChange: (value) {
                          setState(() {
                            orders[index].isSelected = !(orders[index].isSelected);
                            controller.orderDetails.refresh();
                          });
                        },
                        mValue: orders[index].isSelected),
                    const SizedBox(width: 4),

                    InkWell(
                      onTap: (){
                        ImageUtils.moveToImagePreview([FilesInfo(imageUrl: orders[index].productImage ?? "",
                            thumbUrl: orders[index].productThumbImage ?? "")], 0);
                      },
                      child: ImageUtils.setRectangleCornerCachedNetworkImage(
                        url: orders[index].productThumbImage ?? "",
                        width: 90,
                        height: 90,
                        borderRadius: 4,
                        fit: BoxFit.cover,
                      ),
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

                          const SizedBox(height: 4),

                          SubtitleTextView(
                            text: orders[index].uuid ?? "",
                          ),

                          const SizedBox(height: 4),

                          TitleTextView(
                            text: "${'qty'.tr}: ${isSubQuantity ? "${subQty.toInt()} $packOfUnit" : qty.toInt()}",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),

                          const SizedBox(height: 4),

                          TitleTextView(
                            text: "${orderInfo.currency ?? ""}${orders[index].marketPrice ?? "0.00"}",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                /*
                SizedBox(height: 8,),
                if (controller.canShowActionButtons)
                Divider(
                  color: dividerColor_(context),
                ),
                */
                if (item.note?.isNotEmpty ?? false)
                SizedBox(height: 4,),
                if (item.note?.isNotEmpty ?? false)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Shrinks to text width if short
                      crossAxisAlignment: CrossAxisAlignment.start, // Keeps icon at the top
                      children: [
                        Icon(Icons.description, size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TitleTextView(
                            text: "${item.note}",
                            fontSize: 14,
                            maxLine: 30,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isHaveAttachment,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (1 / 1),
                          crossAxisCount: 5,
                          mainAxisSpacing: 7.0,
                          crossAxisSpacing: 7.0, // spacing between columns
                        ),
                        padding: const EdgeInsets.all(8.0),
                        itemCount: (item.attachments ?? []).length,
                        itemBuilder: (context, index) {
                          FilesInfo fileInfo =
                          (item.attachments ?? [])[index];
                          return InkWell(
                            onTap: () async {
                              ImageUtils.moveToImagePreview(
                                  item.attachments!, index);
                            },
                            child: DocumentView(
                                isEditable:false,
                                file: fileInfo.imageUrl ?? "",
                                onRemoveClick: () {

                                }),
                          );
                        },
                      )),
                ),

                /*
                SizedBox(height: 8,),
                if (controller.canShowActionButtons)
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Re-order button pressed');
                        controller.orderAgainAction(false, index);
                      },
                      icon: Icon(Icons.refresh),
                      label: TitleTextView(text: "reorder".tr,
                        fontSize: 15,
                        color: Colors.white,
                      fontWeight: FontWeight.w500,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                )
                */
              ],
            ),
          ),
        );
      },
    );
  }
}