import 'package:belcka/pages/check_in/type_of_work_details/view/widgets/before_after_photos_list.dart';
import 'package:belcka/pages/check_in/type_of_work_details/controller/type_of_work_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/gradient_progressbar.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class TypeOfWorkDetailsScreen extends StatefulWidget {
  const TypeOfWorkDetailsScreen({super.key});

  @override
  State<TypeOfWorkDetailsScreen> createState() =>
      _TypeOfWorkDetailsScreenState();
}

class _TypeOfWorkDetailsScreenState extends State<TypeOfWorkDetailsScreen> {
  final controller = Get.put(TypeOfWorkDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            // title: controller.title.value,
            title: "",
            isCenterTitle: false,
            isBack: false,
            bgColor: dashBoardBgColor_(context),
            onBackPressed: () {
              controller.onBackPress();
            },
          ),
          body: Obx(
            () => ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider(
                    //   thickness: 1,
                    //   height: 1,
                    //   color: dividerColor_(context),
                    // ),
                    Stack(
                      children: [
                        CardViewDashboardItem(
                            elevation: 1,
                            shadowColor: Colors.black45,
                            borderRadius: 12,
                            margin: EdgeInsets.fromLTRB(16, 13, 16, 14),
                            padding: EdgeInsets.fromLTRB(16, 12, 12, 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TitleTextView(
                                    text: controller.info.value.name ?? "",
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Row(
                            children: [
                              textContainerItem(
                                  controller.info.value.tradeName ?? "",
                                  AppUtils.getColor("#FF7F00")),
                              (controller.info.value.isPricework ?? false)
                                  ? textContainerItem(
                                      controller.info.value.rate ?? "",
                                      AppUtils.getColor("#FF008C"))
                                  : textContainerItem(
                                      controller.info.value.repeatableJob ?? "",
                                      AppUtils.getColor("#32A852")),
                            ],
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: !StringHelper.isEmptyString(
                          controller.info.value.locationName),
                      child: SizedBox(
                        width: double.infinity,
                        child: CardViewDashboardItem(
                            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 14),
                            borderRadius: 12,
                            child: TitleTextView(
                              text:
                                  "${'location'.tr}: ${controller.info.value.locationName ?? "-"}",
                            )),
                      ),
                    ),
                    Visibility(
                      visible: !StringHelper.isEmptyString(
                          controller.info.value.duration),
                      child: SizedBox(
                        width: double.infinity,
                        child: CardViewDashboardItem(
                            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 14),
                            borderRadius: 12,
                            child: TitleTextView(
                              text:
                                  "${'estimation_duration'.tr}: ${controller.info.value.duration ?? "-"}",
                            )),
                      ),
                    ),
                    Visibility(
                      visible: controller.isAfterEnable.value,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleTextView(
                              text:
                                  "${'progress'.tr}: ${((controller.info.value.progress ?? 0) != 0 ? (controller.info.value.progress ?? 0) : 100)}%",
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            // SizedBox(
                            //   width: double.infinity,
                            //   child: CustomSlider(
                            //     progress:
                            //         ((controller.info.value.progress ?? 0) != 0
                            //                 ? (controller.info.value.progress ?? 0)
                            //                 : 100)
                            //             .obs,
                            //     onChanged: (newValue) {},
                            //   ),
                            // ),
                            SizedBox(
                              height: 9,
                            ),
                            GradientProgressBar(
                                progress:
                                    ((controller.info.value.progress ?? 0) != 0
                                            ? (controller.info.value.progress ??
                                                0)
                                            : 100) /
                                        100),
                            SizedBox(
                              height: 12,
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.isBeforeEnable.value &&
                          !StringHelper.isEmptyList(
                              controller.beforePhotosList),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TitleTextView(
                              text: 'photos_before'.tr,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          BeforeAfterPhotosList(
                            onGridItemClick: controller.onGridItemClick,
                            filesList: controller.beforePhotosList,
                            photosType: AppConstants.type.beforePhotos,
                            isEditable: controller.isEditable.value,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: controller.isAfterEnable.value &&
                          !StringHelper.isEmptyList(controller.afterPhotosList),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TitleTextView(
                              text: 'photos_after'.tr,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          BeforeAfterPhotosList(
                            onGridItemClick: controller.onGridItemClick,
                            filesList: controller.afterPhotosList,
                            photosType: AppConstants.type.afterPhotos,
                            isEditable: controller.isEditable.value,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget textContainerItem(String text, Color boxColor) {
    return !StringHelper.isEmptyString(text)
        ? Padding(
            padding: const EdgeInsets.only(right: 6, top: 4),
            child: TextViewWithContainer(
              alignment: Alignment.center,
              height: 20,
              text: text ?? "",
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              fontColor: Colors.white,
              fontSize: 12,
              boxColor: boxColor,
              borderRadius: 5,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          )
        : Container();
  }
}
