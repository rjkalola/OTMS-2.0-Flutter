import 'package:belcka/pages/payment_documents/add_invoice/controller/add_invoice_controller.dart';
import 'package:belcka/pages/payment_documents/add_payslip/controller/add_payslip_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../utils/app_constants.dart';

class AddPayslipScreen extends StatefulWidget {
  const AddPayslipScreen({super.key});

  @override
  State<AddPayslipScreen> createState() => _AddPayslipScreenState();
}

class _AddPayslipScreenState extends State<AddPayslipScreen> {
  final controller = Get.put(AddPayslipController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => PopScope(
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
                title: 'add_payslip'.tr,
                isCenterTitle: false,
                isBack: true,
                onBackPressed: () {
                  controller.onBackPress();
                },
                bgColor: dashBoardBgColor_(context),
                widgets: [],
              ),
              body: ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            controller.isInternetNotAvailable.value = false;
                            // controller.getExpenseResourcesApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Expanded(
                                child: Form(
                                  key: controller.formKey,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child: DropDownTextField(
                                                  title: 'from_date'.tr,
                                                  controller: controller
                                                      .fromDateController,
                                                  validators: [],
                                                  onPressed: () {
                                                    controller
                                                        .showDatePickerDialog(
                                                            AppConstants
                                                                .dialogIdentifier
                                                                .startDate,
                                                            controller.fromDate,
                                                            DateTime(1900),
                                                            DateTime(2060));
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child: DropDownTextField(
                                                  title: 'to_date'.tr,
                                                  controller: controller
                                                      .toDateController,
                                                  validators: [],
                                                  onPressed: () {
                                                    if (controller.fromDate !=
                                                        null) {
                                                      controller
                                                          .showDatePickerDialog(
                                                              AppConstants
                                                                  .dialogIdentifier
                                                                  .endDate,
                                                              controller.toDate,
                                                              DateTime(1900),
                                                              DateTime(2060));
                                                    } else {
                                                      AppUtils.showToastMessage(
                                                          'from_date_select_note'
                                                              .tr);
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 24,
                                          ),
                                          PrimaryTextView(
                                            text: 'attachment'.tr,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller
                                                  .showAttachmentOptionsDialog();
                                            },
                                            child: DocumentView(
                                                onRemoveClick: () {},
                                                isEditable: false,
                                                fileRadius: 0,
                                                width: 100,
                                                height: 100,
                                                file:
                                                    (controller.fileUrl.value)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              PrimaryButton(
                                  padding: EdgeInsets.fromLTRB(14, 18, 14, 16),
                                  buttonText: 'save'.tr,
                                  // color: controller.isSaveEnable.value
                                  //     ? defaultAccentColor_(context)
                                  //     : defaultAccentLightColor_(context),
                                  onPressed: () {
                                    // if (controller.isSaveEnable.value) {
                                    if (controller.valid()) {
                                      if (!StringHelper.isEmptyString(
                                          controller.fileUrl.value)) {
                                        controller.addPayslipApi();
                                      } else {
                                        AppUtils.showToastMessage(
                                            'please_select_attachment'.tr);
                                      }
                                    }
                                  })
                            ],
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Divider(
          height: 0,
        ),
      );
}
