import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class ShiftSummeryDialog extends StatefulWidget {
  final String dialogType;
  final SelectItemListener listener;

  const ShiftSummeryDialog(
      {super.key, required this.dialogType, required this.listener});

  @override
  State<ShiftSummeryDialog> createState() =>
      ShiftSummeryDialogState(dialogType, listener);
}

class ShiftSummeryDialogState extends State<ShiftSummeryDialog> {
  String dialogType;
  SelectItemListener listener;
  final typeOfWorkController = TextEditingController();
  final noteController = TextEditingController();
  final listBeforePhotos = <FilesInfo>[].obs;
  final listAfterPhotos = <FilesInfo>[].obs;

  ShiftSummeryDialogState(this.dialogType, this.listener);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) =>
            DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) =>
                      Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12))),
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(mainAxisSize: MainAxisSize.max, children: [
                      Container(
                        margin: EdgeInsets.only(left: 14, top: 10, right: 4),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryTextView(
                              textAlign: TextAlign.start,
                              text: 'shift_summery'.tr,
                              color: primaryTextColor_(context),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.close, size: 20),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        child: Row(
                          children: [
                            checkInBox(
                                title: 'check_in_'.tr,
                                time: "08:00 AM",
                                address: "650, High road, 650, High road,"),
                            SizedBox(
                              width: 14,
                            ),
                            checkInBox(
                                title: 'check_out_'.tr,
                                time: "10:00 AM",
                                address: "650, High road, 650, High road,"),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                        decoration: AppUtils.getGrayBorderDecoration(
                            color: backgroundColor_(context),
                            borderColor: Colors.grey.shade300,
                            radius: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryTextView(
                              textAlign: TextAlign.start,
                              text: 'total_hours_'.tr,
                              color: primaryTextColor_(context),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            PrimaryTextView(
                              textAlign: TextAlign.start,
                              text: "2:00",
                              color: primaryTextColor_(context),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                      ),
                      typeOfWorkWidget(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            photosView(
                                title: 'photos_before'.tr,
                                count: listBeforePhotos.length,
                                photosType: AppConstants.type.beforePhotos,
                                listPhotos: listBeforePhotos),
                            photosView(
                                title: 'photos_after'.tr,
                                count: listAfterPhotos.length,
                                photosType: AppConstants.type.afterPhotos,
                                listPhotos: listAfterPhotos)
                          ],
                        ),
                      ),
                      addNoteWidget(),
                      btnConfirmTimeEditEntry(),
                      // btnSubmitForApproval()
                    ]),
                  ),
                ),
              ),
            ));
  }

  Widget checkInBox(
          {required String title,
          required String time,
          required String address}) =>
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Container(
          decoration: AppUtils.getGrayBorderDecoration(
              color: backgroundColor_(context),
              borderColor: Colors.grey.shade300,
              radius: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 6,
                  bottom: 6,
                ),
                decoration: AppUtils.getGrayBorderDecoration(
                    color: backgroundColor_(context),
                    borderColor: Colors.grey.shade300,
                    radius: 9),
                child: PrimaryTextView(
                  textAlign: TextAlign.center,
                  text: title,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: secondaryLightTextColor_(context),
                ),
              ),
              // Divider(
              //   color: dividerColor,
              //   height: 0,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PrimaryTextView(
                      text: time,
                      color: primaryTextColor_(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // ImageUtils.setSvgAssetsImage(
                    //     path: Drawable.editPencilIcon, width: 13, height: 13)
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
                decoration: AppUtils.getGrayBorderDecoration(
                    color: backgroundColor_(context),
                    borderColor: Colors.grey.shade300,
                    radius: 9),
                child: Row(
                  children: [
                    ImageUtils.setSvgAssetsImage(
                        path: Drawable.locationMapNavigationPointer,
                        width: 18,
                        height: 18),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: PrimaryTextView(
                        textAlign: TextAlign.start,
                        text: address,
                        color: primaryTextColor_(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget photosView(
          {required String title,
          required int count,
          required String photosType,
          required List<FilesInfo> listPhotos}) =>
      Column(
        children: [
          SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  count == 0
                      ? InkWell(
                          onTap: () {
                            print("beforePhotos select");
                            onSelectPhotos(photosType, listPhotos);
                          },
                          child: ImageUtils.setSvgAssetsImage(
                              path: Drawable.addPhotoIcon,
                              width: 70,
                              height: 70),
                        )
                      : InkWell(
                          onTap: () {
                            print("afterPhotos select");
                            onSelectPhotos(photosType, listPhotos);
                          },
                          child: ImageUtils.setSvgAssetsImage(
                              path: Drawable.pictureGalleryIcon,
                              width: 52,
                              height: 52),
                        ),
                  count > 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleWidget(
                                      color:
                                          Color(AppUtils.haxColor("#FF6464")),
                                      width: 26,
                                      height: 26),
                                  PrimaryTextView(
                                    textAlign: TextAlign.start,
                                    text: count.toString(),
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    softWrap: true,
                                  )
                                ],
                              )),
                        )
                      : Container()
                ],
              )),
          PrimaryTextView(
            textAlign: TextAlign.start,
            text: title,
            color: primaryTextColor_(context),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            softWrap: true,
          )
        ],
      );

  Widget addNoteWidget() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: TextFieldBorder(
          textEditingController: noteController,
          hintText: 'enter_your_note_here'.tr,
          labelText: 'add_a_note'.tr,
          textInputAction: TextInputAction.newline,
          validator: MultiValidator([]),
          textAlignVertical: TextAlignVertical.top,
          onValueChange: (value) {},
        ),
      );

  Widget typeOfWorkWidget() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: TextFieldBorder(
            textEditingController: typeOfWorkController,
            hintText: 'type_of_work'.tr,
            labelText: 'type_of_work'.tr,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            isReadOnly: true,
            suffixIcon: const Icon(Icons.arrow_drop_down),
            validator: MultiValidator([]),
            onPressed: () {}),
      );

  Widget btnConfirmTimeEditEntry() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: PrimaryButton(
                  buttonText: 'confirm_time'.tr,
                  onPressed: () {},
                  color: Color(0xff659DF2),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontColor: Colors.white,
                  borderRadius: 45,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Container(
                  height: 40,
                  decoration: AppUtils.getGrayBorderDecoration(
                      color: backgroundColor_(context),
                      borderColor: Color(AppUtils.haxColor("#FFDC4A")),
                      borderWidth: 1.5,
                      radius: 45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageUtils.setSvgAssetsImage(
                          path: Drawable.editPencilIcon, width: 14, height: 14),
                      SizedBox(
                        width: 14,
                      ),
                      PrimaryTextView(
                        text: 'edit_entry'.tr,
                        color: primaryTextColor_(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget btnSubmitForApproval() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: PrimaryButton(
            buttonText: 'submit_for_approval'.tr,
            onPressed: () {},
            color: Color(0xff659DF2),
            fontWeight: FontWeight.w400,
            fontSize: 16,
            fontColor: Colors.white,
            borderRadius: 45,
          ),
        ),
      );

  Future<void> onSelectPhotos(
      String photosType, List<FilesInfo> listPhotos) async {
    var result;
    var arguments = {
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.photosList: listPhotos,
    };
    // result = await Get.toNamed(AppRoutes.selectBeforeAfterPhotosScreen,
    //     arguments: arguments);

    result = await Navigator.of(Get.context!).pushNamed(
        AppRoutes.selectBeforeAfterPhotosScreen,
        arguments: arguments);

    if (result != null) {
      var arguments = result;
      if (arguments != null) {
        photosType = arguments[AppConstants.intentKey.photosType] ?? "";
        if (photosType == AppConstants.type.beforePhotos) {
          listBeforePhotos.clear();
          listBeforePhotos
              .addAll(arguments[AppConstants.intentKey.photosList] ?? []);
        } else if (photosType == AppConstants.type.afterPhotos) {
          listAfterPhotos.clear();
          listAfterPhotos
              .addAll(arguments[AppConstants.intentKey.photosList] ?? []);
        }
      }
    }
  }
}
