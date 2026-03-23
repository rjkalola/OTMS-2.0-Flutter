import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/buyer_app/buyer_order_detail/controller/buyer_order_detail_controller.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class BuyerOrderDetailProductsListItem extends StatelessWidget {
  final ProductInfo item;
  final VoidCallback onListItem;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final int index;
  final int status;

  final controller = Get.find<BuyerOrderDetailController>();

  BuyerOrderDetailProductsListItem(
      {super.key,
      required this.item,
      required this.onListItem,
      required this.onAdd,
      required this.onRemove,
      required this.index,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final bool hideAddImage = status == AppConstants.orderStatus.inStock ||
        status == AppConstants.orderStatus.cancelled;

    /// Note / attachments row always shown; editing + add image off in stock & cancelled.
    final bool canEditNoteSection = !hideAddImage;
    return GestureDetector(
      onTap: onListItem,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: CardViewDashboardItem(
          borderRadius: 10,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUtils.setRectangleCornerCachedNetworkImage(
                    url: item.thumbUrl ?? "",
                    width: 100,
                    height: 100,
                    borderRadius: 4,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextView(
                          text: item.shortName,
                          fontSize: 15,
                          maxLine: 2,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 1),
                        SubtitleTextView(
                          text: item.uuid ?? "",
                          fontSize: 13,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                        const SizedBox(height: 9),
                        controller.status.value !=
                                    AppConstants.orderStatus.inStock &&
                                controller.status.value !=
                                    AppConstants.orderStatus.cancelled
                            ? Row(
                                children: [
                                  OrderQuantityChangeButton(
                                      text: "-", onTap: onRemove),
                                  const SizedBox(width: 8),
                                  OrderQuantityDisplayTextView(
                                    value: (item.cartQty ?? 0).toInt(),
                                    width: 52,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 8),
                                  OrderQuantityChangeButton(
                                      text: "+", onTap: onAdd),
                                ],
                              )
                            : Row(
                                children: [
                                  TitleTextView(
                                    text: "Qty: ",
                                  ),
                                  OrderQuantityDisplayTextView(
                                    value: (item.qty ?? 0).toInt(),
                                    height: 28,
                                  )
                                ],
                              ),
                        const SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          // visible: controller.status.value !=
                          //     AppConstants.orderStatus.received,
                          visible: true,
                          child: Row(
                            children: [
                              TitleTextView(
                                text:
                                    "${'delivered_qty'.tr}: ${item.deliveredQty ?? 0}",
                                fontSize: 13,
                                color: primaryTextColor_(context),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 6, right: 6),
                                width: 1,
                                height: 12,
                                color: secondaryExtraLightTextColor_(context),
                              ),
                              TitleTextView(
                                text:
                                    "${'cancelled_qty'.tr}: ${item.cancelledQty ?? 0}",
                                fontSize: 13,
                                color: primaryTextColor_(context),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Divider(
                    color: dividerColor_(context),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!hideAddImage) ...[
                        GestureDetector(
                          onTap: () {
                            controller.showAttachmentOptionsDialog(index);
                          },
                          child: ImageUtils.setSvgAssetsImage(
                              path: Drawable.addImageIcon,
                              width: 40,
                              height: 40),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                      Expanded(
                          child: TextFieldBorderDark(
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 12, top: 9, bottom: 9),
                        textEditingController:
                            TextEditingController(text: item.note ?? ""),
                        hintText: 'note'.tr,
                        labelText: 'note'.tr,
                        textInputAction: TextInputAction.newline,
                        validator: MultiValidator([]),
                        isReadOnly: !canEditNoteSection,
                        textAlignVertical: TextAlignVertical.top,
                        onValueChange: (value) {
                          item.note = value;
                        },
                        maxLength: 150,
                        fontSize: 14,
                        borderRadius: 10,
                      ))
                    ],
                  ),
                  Visibility(
                    visible: !StringHelper.isEmptyList(item.attachments),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (1 / 1),
                            crossAxisCount: 5,
                            mainAxisSpacing: 7.0,
                            crossAxisSpacing: 7.0,
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
                                  isEditable: canEditNoteSection &&
                                      (fileInfo.id ?? 0) == 0,
                                  file: fileInfo.imageUrl ?? "",
                                  onRemoveClick: () {
                                    item.attachments!.removeAt(index);
                                    controller.orderProductsList.refresh();
                                  }),
                            );
                          },
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
