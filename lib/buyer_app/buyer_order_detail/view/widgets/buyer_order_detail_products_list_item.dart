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
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
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
    bool isEnableEdit = status != AppConstants.orderStatus.inStock;
    bool isQtyNotMatched =
        ((item.qty ?? 0) - (item.deliveredQty ?? 0) - (item.cancelledQty ?? 0))
                .toInt() !=
            (item.cartQty ?? 0);
    bool isHaveAttachment = !StringHelper.isEmptyList(item.tempAttachments);
    print("isEnableEdit:" + isEnableEdit.toString());
    print("isQtyNotMatched:" + isQtyNotMatched.toString());
    print("haveAttachment:" + isHaveAttachment.toString());
    return GestureDetector(
      onTap: onListItem,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: CardViewDashboardItem(
          borderRadius: 10,
          padding: EdgeInsets.fromLTRB(
              controller.isCancelCheck.value ? 4 : 14, 14, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: controller.isCancelCheck.value,
                    child: Container(
                      height: 86,
                      alignment: Alignment.center,
                      child: CustomCheckbox(
                        onValueChange: (value) {
                          item.isCheck = value ?? false;
                          controller.orderProductsList.refresh();
                        },
                        mValue: item.isCheck ?? false,
                      ),
                    ),
                  ),
                  ImageUtils.setRectangleCornerCachedNetworkImage(
                    url: item.thumbUrl ?? "",
                    width: 86,
                    height: 86,
                    borderRadius: 4,
                    fit: BoxFit.contain,
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
                              child: TitleTextView(
                                text: item.shortName,
                                fontSize: 15,
                                maxLine: 2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Visibility(
                                visible: !StringHelper.isEmptyList(
                                        item.notes) ||
                                    !StringHelper.isEmptyList(item.attachments),
                                child: GestureDetector(
                                  onTap: () {
                                    _showNotesAttachmentsBottomSheet(context);
                                  },
                                  child: ImageUtils.setSvgAssetsImage(
                                      path: Drawable.historyIcon,
                                      width: 24,
                                      height: 24),
                                )),
                          ],
                        ),
                        SubtitleTextView(
                          text: item.uuid ?? "",
                          fontSize: 13,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                        if (item.isCheck ?? false) const SizedBox(height: 9),
                        if (item.isCheck ?? false)
                          Row(
                            children: [
                              OrderQuantityChangeButton(
                                  text: "-", onTap: onRemove),
                              const SizedBox(width: 8),
                              OrderQuantityDisplayTextView(
                                value: (item.cartQty ?? 0).toInt(),
                                width: 52,
                                height: 30,
                              ),
                              Visibility(
                                visible: isQtyNotMatched,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: OrderQuantityChangeButton(
                                      text: "+", onTap: onAdd),
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              TitleTextView(
                                text:
                                    "${'ordered'.tr}: ${(item.qty ?? 0).toInt()}",
                                fontSize: 13,
                                color: primaryTextColor_(context),
                              ),
                              Container(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Visibility(
                visible: isEnableEdit && isQtyNotMatched,
                child: Column(
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
                      children: [
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
                        Expanded(
                            child: TextFieldBorderDark(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 12, right: 12, top: 9, bottom: 9),
                          textEditingController:
                              TextEditingController(text: item.tempNote ?? ""),
                          hintText: 'note'.tr,
                          labelText: 'note'.tr,
                          textInputAction: TextInputAction.newline,
                          validator: MultiValidator([]),
                          isReadOnly: false,
                          textAlignVertical: TextAlignVertical.top,
                          onValueChange: (value) {
                            item.tempNote = value;
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
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: (1 / 1),
                              crossAxisCount: 5,
                              mainAxisSpacing: 7.0,
                              crossAxisSpacing: 7.0,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            itemCount: (item.tempAttachments ?? []).length,
                            itemBuilder: (context, index) {
                              FilesInfo fileInfo =
                                  (item.tempAttachments ?? [])[index];
                              return InkWell(
                                onTap: () async {
                                  ImageUtils.moveToImagePreview(
                                      item.tempAttachments!, index);
                                },
                                child: DocumentView(
                                    isEditable:
                                        isEnableEdit && (fileInfo.id ?? 0) == 0,
                                    file: fileInfo.imageUrl ?? "",
                                    onRemoveClick: () {
                                      item.tempAttachments!.removeAt(index);
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

  void _showNotesAttachmentsBottomSheet(BuildContext context) {
    final notes = item.notes ?? <String>[];
    final attachments =
        item.tempAttachments ?? item.attachments ?? <FilesInfo>[];

    Get.bottomSheet(
      SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleTextView(
                    text: 'notes'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  if (notes.isEmpty)
                    SubtitleTextView(
                      text: "-",
                      fontSize: 14,
                      color: secondaryExtraLightTextColor_(context),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < notes.length; i++) ...[
                          if (i > 0) ...[
                            SizedBox(height: 10),
                            Divider(
                              height: 1,
                              color: dividerColor_(context),
                            ),
                            SizedBox(height: 10),
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: primaryTextColor_(context),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SubtitleTextView(
                                  text: notes[i],
                                  fontSize: 15,
                                  color: primaryTextColor_(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 18),
                  TitleTextView(
                    text: 'attachments'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  if (attachments.isEmpty)
                    SubtitleTextView(
                      text: "-",
                      fontSize: 14,
                      color: secondaryExtraLightTextColor_(context),
                    )
                  else
                    GridView.builder(
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
                      itemCount: attachments.length,
                      itemBuilder: (context, index) {
                        final fileInfo = attachments[index];
                        return InkWell(
                          onTap: () async {
                            Get.back();
                            Future.microtask(() =>
                                ImageUtils.moveToImagePreview(
                                    attachments, index));
                          },
                          child: DocumentView(
                            isEditable: false,
                            file: fileInfo.thumbUrl ?? "",
                            onRemoveClick: () {},
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  PrimaryBorderButton(
                    buttonText: 'close'.tr,
                    fontWeight: FontWeight.w400,
                    fontColor: secondaryLightTextColor_(context),
                    borderColor: secondaryExtraLightTextColor_(context),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
