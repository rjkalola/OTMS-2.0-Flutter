import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/storeman_app/storeman_order_details/controller/storeman_order_details_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/gridview/document_gridview.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class StoremanOrderProductsListItem extends StatelessWidget {
  final ProductInfo item;
  final VoidCallback onListItem;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final int index;
  final int status;

  final controller = Get.find<StoremanOrderDetailsController>();

  StoremanOrderProductsListItem(
      {super.key,
      required this.item,
      required this.onListItem,
      required this.onAdd,
      required this.onRemove,
      required this.index,
      required this.status});

  @override
  Widget build(BuildContext context) {
    bool isEnableEdit = status != AppConstants.orderStatus.inStock;
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
                        controller.status ==
                                    AppConstants.orderStatus.processing ||
                                controller.status ==
                                    AppConstants.orderStatus.partialReceived
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
                        SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: controller.status !=
                              AppConstants.orderStatus.received,
                          child: TitleTextView(
                            text:
                                "${'received_qty'.tr}: ${item.receivedQty ?? 0}",
                            fontSize: 13,
                            color: primaryTextColor_(context),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Visibility(
                visible: (item.qty ?? 0).toInt() != (item.cartQty ?? 0) ||
                    (status == AppConstants.orderStatus.inStock &&
                        !StringHelper.isEmptyList(item.attachments)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Divider(
                      color: dividerColor_(context),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: isEnableEdit,
                          child: GestureDetector(
                            onTap: () {
                              controller.showAttachmentOptionsDialog(index);
                            },
                            child: ImageUtils.setSvgAssetsImage(
                                path: Drawable.addImageIcon,
                                width: 40,
                                height: 40),
                          ),
                        ),
                        Visibility(
                          visible: isEnableEdit,
                          child: SizedBox(
                            width: 6,
                          ),
                        ),
                        Expanded(
                            child: TextFieldBorderDark(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 12, right: 12, top: 9, bottom: 9),
                          textEditingController:
                              TextEditingController(text: item.note ?? ""),
                          hintText: 'note'.tr,
                          labelText: 'note'.tr,
                          textInputAction: TextInputAction.newline,
                          validator: MultiValidator([]),
                          isEnabled: isEnableEdit,
                          isReadOnly: !isEnableEdit,
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
                      visible: (item.attachments ?? []).isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: DocumentGridview(
                            isEditable: isEnableEdit,
                            crossAxisCount: 5,
                            physics: const NeverScrollableScrollPhysics(),
                            filesList: (item.attachments ?? []).obs,
                            onViewClick: (int index) async {
                              // String fileUrl = item.attachments![index].imageUrl??"";
                              // await ImageUtils.openAttachment(
                              //     Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
                              ImageUtils.moveToImagePreview(
                                  item.attachments!, index);
                            },
                            onRemoveClick: (int index) {
                              item.attachments!.removeAt(index);
                              controller.orderProductsList.refresh();
                              // onGridItemClick(index, AppConstants.action.removePhoto);
                            }),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
