import 'package:belcka/pages/profile/health_and_safety/near_miss_reporting/controller/near_miss_reporting_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/selector_card.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/styled_text_field.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NearMissReportingScreen extends StatefulWidget {
  const NearMissReportingScreen({super.key});

  @override
  State<NearMissReportingScreen> createState() => _NearMissReportingScreenState();
}

class _NearMissReportingScreenState extends State<NearMissReportingScreen> {
  final controller = Get.put(NearMissReportingController());

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
          top: false,
          child: Obx(
                () => GestureDetector(
                  onTap: (){
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Scaffold(
                                backgroundColor: dashBoardBgColor_(context),
                                appBar: OrdersBaseAppBar(
                  appBar: AppBar(),
                  title: 'near_miss_reporting'.tr,
                  isCenterTitle: false,
                  isBack: true,
                  bgColor: backgroundColor_(context),
                  onBackPressed: (){
                    controller.onBackPress();
                  },
                                ),
                                body: ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                    onPressed: () {
                      controller.isInternetNotAvailable.value = false;
                    },
                  )
                      : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Hazard Type Selector ---
                            TitleTextView(text: "hazard_type".tr,fontWeight: FontWeight.w500,),
                            const SizedBox(height: 8),
                            SelectorCard(placeholder: "select_hazard_type".tr, text: ""),
                            const SizedBox(height: 16),

                            // --- Description Field ---
                            TitleTextView(text: "description".tr,fontWeight: FontWeight.w500,),
                            const SizedBox(height: 8),
                            StyledTextField(hintText: "${'write_description_here'.tr}..."),
                            const SizedBox(height: 16),

                            // --- THE UPLOAD SECTION ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 TitleTextView(text: "${'upload_photo'.tr} / ${'Video'.tr}",fontWeight: FontWeight.w500,),
                                // Conditionally show 'Clear' button
                                if (controller.selectedMedia != null)
                                  TextButton.icon(
                                    onPressed: controller.clearMedia,
                                    icon: const Icon(Icons.close_rounded, size: 16, color: Colors.redAccent),
                                    label: Text("clear".tr, style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                                  )
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Conditional Rendering of the Upload Area:
                            if (controller.selectedMedia == null)
                            // 1. Placeholder / Upload Action Card
                              GestureDetector(
                                onTap: (){

                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: backgroundColor_(context),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1.5, style: BorderStyle.solid),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.blueAccent.withOpacity(0.7)),
                                      const SizedBox(height: 12),
                                      Text(
                                        "tap_to_upload_media".tr,
                                        style: TextStyle(fontWeight: FontWeight.w500,),
                                      ),
                                      Text(
                                        "(${"photo_video".tr})",
                                        style: TextStyle(fontSize: 12,),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            else
                            // 2. The Selected Media Display
                              Container(
                                width: double.infinity,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    controller.selectedMedia!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      )
                  )

                                ),
                    bottomNavigationBar: SafeArea(
                      child: Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Opacity(
                            opacity: 1.0,
                            child: PrimaryButton(
                              buttonText: "save".tr,
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                              ),
                ),
          ),
        ),
      ),
    );
  }

}