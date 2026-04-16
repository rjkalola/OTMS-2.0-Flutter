import 'package:belcka/pages/profile/health_and_safety/report_incident/controller/report_incident_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/attachment_section.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/audio_reporting_widget.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/multi_audio_grid_widget.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/selector_card.dart';
import 'package:belcka/pages/profile/health_and_safety/widgets/styled_text_field.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final controller = Get.put(ReportIncidentController());
  bool _isIncidentDropdownOpen = false;
  bool _isThreatLevelDropdownOpen = false;
  bool _isUserDropdownOpen = false;

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
                  title: 'report_incident'.tr,
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
                              //text field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Label
                                  RichText(
                                    text: TextSpan(
                                      text: '${'title'.tr} ',
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

                                  // TextField - Removed fixed height Container
                                  TextField(
                                    controller: controller.titleController,
                                    style: TextStyle(fontSize: 15, color: primaryTextColor_(context)),
                                    decoration: InputDecoration(
                                      hintText: "${'enter_report_title'.tr}...",
                                      hintStyle: TextStyle(color: secondaryTextColor_(context),fontSize: 15),
                                      filled: true,
                                      fillColor: backgroundColor_(context),
                                      // Padding controls the height dynamically
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                                      // Use borders inside decoration instead of Container decoration
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.black12, width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: defaultAccentColor_(context), width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // --- Incident Type Selector ---
                              RichText(
                                text: TextSpan(
                                  text: '${'incident_type'.tr} ',
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
                                    placeholder: "select_incident_type".tr,
                                    text: controller.selectedIncidentType?.title ?? "",
                                    isOpen: _isIncidentDropdownOpen,
                                    onTap: () {
                                      setState(() {
                                        FocusManager.instance.primaryFocus?.unfocus();

                                        if (controller.healthAndSafetyService.incidentTypes.isEmpty){
                                          AppUtils.showSnackBarMessage('no_incident_types_found'.tr);
                                        }
                                        else{
                                          setState(() {
                                            _isIncidentDropdownOpen = !_isIncidentDropdownOpen; // Toggle open/close
                                            _isThreatLevelDropdownOpen = false;
                                            _isUserDropdownOpen = false;
                                          });
                                        }

                                      });
                                    },
                                  ),

                                  // The actual Dropdown Menu
                                  if (_isIncidentDropdownOpen)
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
                                        children: controller.healthAndSafetyService.incidentTypes.map((incident) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                controller.selectedIncidentType = incident; // Change selection status
                                                _isIncidentDropdownOpen = false;  // Close the dropdown
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(16),
                                              decoration: const BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
                                              ),
                                              child: Text(
                                                incident.title,
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

                              // --- Threat Level Selector ---
                              RichText(
                                text: TextSpan(
                                  text: '${'threat_level_assessment'.tr} ',
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
                                    placeholder: "select_threat_level_assessment".tr,
                                    text: controller.selectedThreatLevel?.title ?? "",
                                    isOpen: _isThreatLevelDropdownOpen,
                                    onTap: () {
                                      setState(() {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        if (controller.healthAndSafetyService.threatLevels.isEmpty){
                                          AppUtils.showSnackBarMessage('no_threat_levels_found'.tr);
                                        }
                                        else{
                                          setState(() {
                                            _isThreatLevelDropdownOpen = !_isThreatLevelDropdownOpen; // Toggle open/close
                                            _isIncidentDropdownOpen = false;
                                            _isUserDropdownOpen = false;
                                          });
                                        }

                                      });
                                    },
                                  ),

                                  // The actual Dropdown Menu
                                  if (_isThreatLevelDropdownOpen)
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
                                        children: controller.healthAndSafetyService.threatLevels.map((threatLevel) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                controller.selectedThreatLevel = threatLevel; // Change selection status
                                                _isThreatLevelDropdownOpen = false;  // Close the dropdown
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(16),
                                              decoration: const BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
                                              ),
                                              child: Text(
                                                threatLevel.title,
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

                              // --- Notify Selector ---
                              RichText(
                                text: TextSpan(
                                  text: '${'notify_to'.tr} ',
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
                                    placeholder: "select_user".tr,
                                    text: controller.selectedUser?.name ?? "",
                                    isOpen: _isUserDropdownOpen,
                                    onTap: () {
                                      setState(() {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        if (controller.healthAndSafetyService.users.isEmpty){
                                          AppUtils.showSnackBarMessage('no_data_found'.tr);
                                        }
                                        else{
                                          setState(() {
                                            _isUserDropdownOpen = !_isUserDropdownOpen;
                                            _isThreatLevelDropdownOpen = false;
                                            _isIncidentDropdownOpen = false;
                                          });
                                        }
                                      });
                                    },
                                  ),

                                  // The actual Dropdown Menu
                                  if (_isUserDropdownOpen)
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
                                        children: controller.healthAndSafetyService.users.map((selectedUser) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                controller.selectedUser = selectedUser;
                                                _isUserDropdownOpen = false;
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              decoration: const BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
                                              ),
                                              child: Row(
                                                children: [
                                                  // User Photo
                                                  UserAvtarView(
                                                    imageSize: 32,
                                                    imageUrl: selectedUser.userThumbImage ?? "",
                                                  ),
                                                  const SizedBox(width: 12), // Space between photo and name
                                                  // User Name
                                                  Expanded(
                                                    child: Text(
                                                      selectedUser.name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xFF1A1C1E),
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              //Audio file
                              //MultiAudioGridWidget(),

                              // --- Description Field ---
                        /*
                              TitleTextView(text: "description".tr,fontWeight: FontWeight.w500,fontSize: 15,),
                              const SizedBox(height: 8),
                              StyledTextField(
                                hintText: "${'write_description_here'.tr}...",
                                controller: controller.descriptionController,
                              ),
                              const SizedBox(height: 16),
                              */
                              // --- THE UPLOAD SECTION ---
                              AttachmentSection(
                                isMandatoryField: true,
                                attachmentList: controller.attachmentList,
                                onFilesSelected: (files) => controller.attachmentList.addAll(files),
                                onDelete: (index) => controller.attachmentList.removeAt(index),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        )
                    )

                                ),
                                bottomNavigationBar: SafeArea(
                  child: Visibility(
                    visible:true,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Opacity(
                        opacity: 1.0,
                        child: PrimaryButton(
                          buttonText: "submit_incident".tr,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            List<String> errors = [];

                            if (controller.titleController.text.trim().isEmpty) errors.add('title_is_required'.tr);
                            if (controller.selectedIncidentType == null) errors.add('incident_type_required'.tr);
                            if (controller.selectedThreatLevel == null) errors.add('threat_level_required'.tr);
                            if (controller.selectedUser == null) errors.add('notify_to_required'.tr);
                            if (controller.attachmentList.isEmpty) errors.add('one_file_required'.tr);

                            if (errors.isNotEmpty) {
                              AppUtils.showSnackBarMessage(errors.join('\n'));
                            }
                            else{
                              controller.storeReportIncident();
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