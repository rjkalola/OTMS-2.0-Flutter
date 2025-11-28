import 'package:belcka/pages/check_in/check_in/controller/check_in_controller.dart';
import 'package:belcka/pages/check_in/check_in/view/widgets/selected_type_of_work.dart';
import 'package:belcka/pages/check_in/widgets/start_stop_time_box.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/textfield/reusable/add_note_widget.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final controller = Get.put(CheckInController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'check_in_'.tr,
          isCenterTitle: false,
          isBack: true,
          bgColor: dashBoardBgColor_(context),
          // widgets: actionButtons()
        ),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: controller.isMainViewVisible.value,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              // SelectionScreenHeaderView(
                              //   title: 'check_in_'.tr,
                              //   onBackPressed: () {
                              //     Get.back();
                              //   },
                              // ),
                              Row(
                                children: [
                                  StartStopTimeBox(
                                      title: 'check_in_'.tr,
                                      time: controller.checkInTime,
                                      address: "",
                                      isEditVisible: false.obs)
                                ],
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              DropDownTextField(
                                title: 'select_address'.tr,
                                controller: controller.addressController,
                                borderRadius: 15,
                                validators: [
                                  RequiredValidator(
                                      errorText: 'required_field'.tr),
                                ],
                                onPressed: () {
                                  controller.showSelectAddressDialog();
                                },
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              DropDownTextField(
                                title: 'select_trade'.tr,
                                controller: controller.tradeController,
                                borderRadius: 15,
                                onPressed: () {
                                  controller.showSelectTradeDialog();
                                },
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              DropDownTextField(
                                title: 'type_of_work'.tr,
                                controller: controller.typeOfWorkController,
                                borderRadius: 15,
                                validators: [
                                  RequiredValidator(
                                      errorText: 'required_field'.tr),
                                ],
                                onPressed: () {
                                  controller.showSelectTypeOfWorkDialog();
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              SelectedTypeOfWork(),
                              // DropDownTextField(
                              //   title: 'location'.tr,
                              //   controller: controller.locationController,
                              //   borderRadius: 15,
                              //   onPressed: () {
                              //     controller.showSelectLocationDialog();
                              //   },
                              // ),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              /*  PhotosCountView(
                                title: 'photos_before'.tr,
                                count: controller.listBeforePhotos.length,
                                photosType: AppConstants.type.beforePhotos,
                                onPressed: () {
                                  controller.onSelectPhotos(
                                      AppConstants.type.beforePhotos,
                                      controller.listBeforePhotos);
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),*/
                              AddNoteWidget(
                                controller: controller.noteController,
                                borderRadius: 15,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 200,
                                child: CustomMapView(
                                  onMapCreated: controller.onMapCreated,
                                  target: controller.center,
                                  markers: controller.markers,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: PrimaryButton(
                      buttonText: 'check_in_'.tr,
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.checkInApi();
                          // if (controller.isValidPhotos()) {
                          //   controller.checkInApi();
                          // } else {
                          //   AppUtils.showToastMessage(
                          //       'msg_empty_before_attachment'.tr);
                          // }
                        }
                      },
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
