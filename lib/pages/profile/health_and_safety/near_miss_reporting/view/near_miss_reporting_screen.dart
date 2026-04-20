import 'package:belcka/pages/profile/health_and_safety/near_miss_reporting/controller/near_miss_reporting_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/attachment_section.dart';
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
  bool _isDropdownOpen = false;

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
                  title: controller.appBarTitle.value.tr,
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
                            RichText(
                              text: TextSpan(
                                text: '${'hazard_type'.tr} ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:primaryTextColor_(context),
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: [
                                SelectorCard(
                                  placeholder: "select_hazard_type".tr,
                                  text: controller.selectedHazard.value?.title ?? "",
                                  isOpen: _isDropdownOpen,
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    if (controller.healthAndSafetyService.hazards.isEmpty){
                                      AppUtils.showSnackBarMessage('no_hazards_found'.tr);
                                    }
                                    else{
                                      setState(() {
                                        _isDropdownOpen = !_isDropdownOpen; // Toggle open/close
                                      });
                                    }
                                  },
                                ),

                                // The actual Dropdown Menu
                                if (_isDropdownOpen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: controller.healthAndSafetyService.hazards.map((hazard) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              controller.selectedHazard.value = hazard; // Change selection status
                                              _isDropdownOpen = false;  // Close the dropdown
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
                                            ),
                                            child: Text(
                                              hazard.title,
                                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // --- Description Field ---
                            TitleTextView(text: "description".tr,fontWeight: FontWeight.w500,fontSize: 15,),
                            const SizedBox(height: 8),
                            StyledTextField(
                              hintText: "${'write_description_here'.tr}...",
                              controller: controller.descriptionController,
                            ),
                            const SizedBox(height: 16),

                            // --- THE UPLOAD SECTION ---
                            GestureDetector(
                              onTap: (){
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: AttachmentSection(
                                attachmentList: controller.attachmentList,
                                onFilesSelected: (files) => controller.attachmentList.addAll(files),
                                onDelete: (index) {

                                },
                                deletedAttachmentIds: controller.deletedAttachmentIds,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      )
                  )),
                    bottomNavigationBar: SafeArea(
                      child: Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Opacity(
                            opacity: 1.0,
                            child: PrimaryButton(
                              buttonText: controller.saveButtonTitle.value.tr,
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (controller.selectedHazard.value == null){
                                  AppUtils.showSnackBarMessage('please_select_hazard_type'.tr);
                                }
                                else{
                                  controller.storeNearMissReport();
                                }
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