import 'package:belcka/pages/digital_id_card/controller/digital_id_card_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/shapes/circle_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigitalIdCardScreen extends StatefulWidget {
  const DigitalIdCardScreen({super.key});

  @override
  State<DigitalIdCardScreen> createState() => _DigitalIdCardScreenState();
}

class _DigitalIdCardScreenState extends State<DigitalIdCardScreen> {
  final controller = Get.put(DigitalIdCardController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'digital_id_card'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getDigitalCardDetailsApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: controller.webViewController != null
                            ? WebViewWidget(
                                controller: controller.webViewController!)
                            : Container(),
                        /*  child: Center(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            decoration: AppUtils.getDashboardItemDecoration(
                                color: AppUtils.getColor("#d4ecf6"),
                                borderColor: AppUtils.getColor("#a9cbda"),
                                borderWidth: 6,
                                radius: 20),
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ImageUtils.setAssetsImage(
                                      path: Drawable.imgHeaderLogo,
                                      width: 120,
                                      height: 60),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PrimaryTextView(
                                                text: controller
                                                        .digitalIdCardInfo
                                                        .value
                                                        .firstName ??
                                                    "",
                                                fontSize: 26,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              PrimaryTextView(
                                                text: controller
                                                        .digitalIdCardInfo
                                                        .value
                                                        .lastName ??
                                                    "",
                                                fontSize: 26,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              PrimaryTextView(
                                                text:
                                                    "${'user_id'.tr}: ${controller.digitalIdCardInfo.value.userId ?? 0}"
                                                        .toUpperCase(),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              PrimaryTextView(
                                                text: controller
                                                        .digitalIdCardInfo
                                                        .value
                                                        .tradeName ??
                                                    "",
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              PrimaryTextView(
                                                text: 'joined'.tr.toUpperCase(),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              PrimaryTextView(
                                                text: controller
                                                        .digitalIdCardInfo
                                                        .value
                                                        .joinedOn ??
                                                    "",
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              PrimaryTextView(
                                                text: controller
                                                        .digitalIdCardInfo
                                                        .value
                                                        .companyName ??
                                                    "",
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 22,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ImageUtils.setUserImage(
                                                url: controller
                                                        .digitalIdCardInfo
                                                        .value
                                                        .userImage ??
                                                    "",
                                                width: 120,
                                                height: 120)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ImageUtils
                                          .setRectangleCornerCachedNetworkImage(
                                              url: controller.digitalIdCardInfo
                                                      .value.qrCodeUrl ??
                                                  "",
                                              width: 180,
                                              height: 180,
                                              borderRadius: 12),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircleWidget(
                                                  color: Colors.white,
                                                  width: 24,
                                                  height: 24),
                                              Icon(
                                                Icons.check_circle_rounded,
                                                size: 28,
                                                color: Colors.green,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          PrimaryTextView(
                                            text: 'active'.tr,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: PrimaryTextView(
                                      text:
                                          'digital_id_slogan'.tr.toUpperCase(),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),*/
                      )),
          ),
        ),
      ),
    );
  }

// List<Widget>? actionButtons() {
//   return [
//     Visibility(
//       visible: controller.isAllUserTeams.value,
//       child: IconButton(
//         icon: Icon(Icons.more_vert_outlined),
//         onPressed: () {
//           controller.showMenuItemsDialog(Get.context!);
//         },
//       ),
//     ),
//   ];
// }
}
