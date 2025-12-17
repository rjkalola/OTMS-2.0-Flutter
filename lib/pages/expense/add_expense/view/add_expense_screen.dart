import 'package:belcka/pages/expense/add_expense/controller/add_expense_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/gridview/document_gridview.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../utils/app_constants.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final controller = Get.put(AddExpenseController());

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
              title: controller.title.value,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
              widgets: actionButtons(),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getExpenseResourcesApi();
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 14),
                                        child: DropDownTextField(
                                          title: 'project'.tr,
                                          controller:
                                              controller.projectController,
                                          validators: [
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                          ],
                                          isArrowHide: !controller
                                              .isProjectDropDownEnable.value,
                                          onPressed: () {
                                            if (controller
                                                .isProjectDropDownEnable
                                                .value) {
                                              controller
                                                  .showSelectProjectDialog();
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 24),
                                        child: DropDownTextField(
                                          title: 'address'.tr,
                                          controller:
                                              controller.addressController,
                                          validators: [
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                          ],
                                          onPressed: () {
                                            controller
                                                .showSelectAddressDialog();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 24),
                                        child: DropDownTextField(
                                          title: 'category'.tr,
                                          controller:
                                              controller.categoryController,
                                          validators: [
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                          ],
                                          onPressed: () {
                                            controller
                                                .showSelectCategoryDialog();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 24, 20, 0),
                                        child: TextFieldBorderDark(
                                          textEditingController: controller
                                              .sumOfTotalController.value,
                                          hintText: 'sum_of_total'.tr,
                                          labelText: 'sum_of_total'.tr,
                                          isReadOnly: false,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          onValueChange: (value) {
                                            controller.isSaveEnable.value =
                                                true;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]')),
                                          ],
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                            PatternValidator(r'^\d+(\.\d+)?$',
                                                errorText:
                                                    'enter_valid_amount'.tr),
                                          ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 24),
                                        child: DropDownTextField(
                                          title: 'date_of_receipt'.tr,
                                          controller: controller
                                              .dateOfReceiptController,
                                          validators: [
                                            RequiredValidator(
                                                errorText: 'required_field'.tr),
                                          ],
                                          onPressed: () {
                                            controller.showDatePickerDialog(
                                                AppConstants.dialogIdentifier
                                                    .selectDate,
                                                controller.selectDate,
                                                DateTime(1900),
                                                DateTime.now());
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 24, 20, 0),
                                        child: TextFieldBorderDark(
                                          textEditingController:
                                              controller.noteController.value,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          hintText: 'note'.tr,
                                          labelText: 'note'.tr,
                                          textInputAction:
                                              TextInputAction.newline,
                                          validator: MultiValidator([]),
                                          isReadOnly: false,
                                          minLines: 3,
                                          maxLength: 500,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          textAlign: TextAlign.start,
                                          onValueChange: (value) {
                                            controller.isSaveEnable.value =
                                                true;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 24, 20, 0),
                                        child: PrimaryTextView(
                                          text: 'attachment'.tr,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            11, 6, 11, 0),
                                        child: DocumentGridview(
                                            isEditable: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            filesList:
                                                controller.attachmentList,
                                            onViewClick: (int index) {
                                              controller.onGridItemClick(
                                                  index,
                                                  AppConstants
                                                      .action.viewPhoto);
                                            },
                                            onRemoveClick: (int index) {
                                              controller.onGridItemClick(
                                                  index,
                                                  AppConstants
                                                      .action.removePhoto);
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                                padding: EdgeInsets.fromLTRB(14, 18, 14, 16),
                                buttonText: 'save'.tr,
                                color: controller.isSaveEnable.value
                                    ? defaultAccentColor_(context)
                                    : defaultAccentLightColor_(context),
                                onPressed: () {
                                  if (controller.isSaveEnable.value) {
                                    if (controller.valid()) {
                                      if (controller.attachmentList.length >
                                          1) {
                                        if (controller.expenseId != 0) {
                                          controller.editExpenseApi();
                                        } else {
                                          controller.addExpenseApi();
                                        }
                                      } else {
                                        AppUtils.showToastMessage(
                                            'please_select_image'.tr);
                                      }
                                    }
                                  }
                                })
                          ],
                        ),
                      )),
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

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: controller.expenseId.value != 0,
        child: TextButton(
            onPressed: () {
              controller.showRemoveDialog();
            },
            child: TitleTextView(
              text: 'delete'.tr,
              color: Colors.red,
            )),
      ),
      SizedBox(width: 6,)
    ];
  }
}
