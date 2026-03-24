import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/storeman_app/storeman_order_details/controller/storeman_order_details_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/gridview/document_gridview.dart';
import 'package:belcka/widgets/image/document_view.dart';
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
    bool isQtyNotMatched =
        ((item.qty ?? 0) - (item.deliveredQty ?? 0) - (item.cancelledQty ?? 0))
                .toInt() !=
            (item.cartQty ?? 0);
    bool isHaveAttachment = !StringHelper.isEmptyList(item.attachments);
    bool isHaveNote = !StringHelper.isEmptyString(item.note);
    print("isEnableEdit:" + isEnableEdit.toString());
    print("isQtyNotMatched:" + isQtyNotMatched.toString());
    print("haveAttachment:" + isHaveAttachment.toString());
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
                          child: Row(
                            children: [
                              TitleTextView(
                                text:
                                    "${'ordered'.tr}: ${(item.qty ?? 0).toInt()}",
                                fontSize: 13,
                                color: primaryTextColor_(context),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 6, right: 6),
                                width: 1,
                                height: 12,
                                color: secondaryExtraLightTextColor_(context),
                              ),
                              TitleTextView(
                                text:
                                    "${'delivered'.tr}: ${item.deliveredQty ?? 0}",
                                fontSize: 13,
                                color: primaryTextColor_(context),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 6, right: 6),
                                width: 1,
                                height: 12,
                                color: secondaryExtraLightTextColor_(context),
                              ),
                              TitleTextView(
                                text:
                                    "${'cancelled'.tr}: ${item.cancelledQty ?? 0}",
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
              SizedBox(
                height: 4,
              ),
              Visibility(
                visible: isQtyNotMatched ||
                    (((status == AppConstants.orderStatus.inStock ||
                            status ==
                                AppConstants.orderStatus.partialReceived ||
                            status == AppConstants.orderStatus.cancelled)) &&
                        (isHaveNote || isHaveAttachment)),
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
                          visible: isEnableEdit && isQtyNotMatched,
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
                          visible: isEnableEdit && isQtyNotMatched,
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
                          isReadOnly: !(isEnableEdit && isQtyNotMatched),
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
                      visible: isHaveAttachment,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          // child: DocumentGridview(
                          //     isEditable: isEnableEdit,
                          //     crossAxisCount: 5,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     filesList: (item.attachments ?? []).obs,
                          //     onViewClick: (int index) async {
                          //       // String fileUrl = item.attachments![index].imageUrl??"";
                          //       // await ImageUtils.openAttachment(
                          //       //     Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
                          //       ImageUtils.moveToImagePreview(
                          //           item.attachments!, index);
                          //     },
                          //     onRemoveClick: (int index) {
                          //       item.attachments!.removeAt(index);
                          //       controller.orderProductsList.refresh();
                          //       // onGridItemClick(index, AppConstants.action.removePhoto);
                          //     }),
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
                                  // String fileUrl = item.attachments![index].imageUrl??"";
                                  // await ImageUtils.openAttachment(
                                  //     Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
                                  ImageUtils.moveToImagePreview(
                                      item.attachments!, index);
                                },
                                child: DocumentView(
                                    isEditable:
                                        isEnableEdit && (fileInfo.id ?? 0) == 0,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
