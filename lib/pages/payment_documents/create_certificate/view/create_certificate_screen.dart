import 'package:belcka/pages/payment_documents/create_certificate/controller/create_certificate_controller.dart';
import 'package:belcka/pages/payment_documents/create_certificate/view/widgets/certificate_file_upload_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateCertificateScreen extends StatefulWidget {
  const CreateCertificateScreen({super.key});

  @override
  State<CreateCertificateScreen> createState() =>
      _CreateCertificateScreenState();
}

class _CreateCertificateScreenState extends State<CreateCertificateScreen> {
  final controller = Get.put(CreateCertificateController());

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
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'upload_certificate'.tr,
                isCenterTitle: false,
                isBack: true,
                onBackPressed: controller.onBackPress,
                bgColor: backgroundColor_(context),
                elevation: 5,
                shadowColor: shadowColor_(context).withValues(alpha: 0.28),
                surfaceTintColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                widgets: const [],
              ),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.loadCertificateTypes(true);
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
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        DropDownTextField(
                                          title: 'certificate_type'.tr,
                                          controller: controller
                                              .certificateTypeController,
                                          validators: [
                                            RequiredValidator(
                                              errorText: 'required_field'.tr,
                                            ),
                                          ],
                                          onPressed: controller
                                              .showCertificateTypeDialog,
                                        ),
                                        Obx(
                                          () => Visibility(
                                            visible: controller
                                                .isDocumentTypeVisible.value,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20),
                                                DropDownTextField(
                                                  title: 'document_type'.tr,
                                                  controller: controller
                                                      .documentTypeController,
                                                  validators: [
                                                    RequiredValidator(
                                                      errorText:
                                                          'required_field'.tr,
                                                    ),
                                                  ],
                                                  onPressed: controller
                                                      .showDocumentTypeDialog,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        DropDownTextField(
                                          title: 'expiry_date'.tr,
                                          controller:
                                              controller.expiryDateController,
                                          validators: [
                                            RequiredValidator(
                                              errorText: 'required_field'.tr,
                                            ),
                                          ],
                                          onPressed:
                                              controller.showExpiryDatePicker,
                                        ),
                                        const SizedBox(height: 20),
                                        TextFieldBorder(
                                          textEditingController: controller
                                              .documentNumberController.value,
                                          hintText: 'document_number'.tr,
                                          labelText: 'document_number'.tr,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          autovalidateMode:
                                              AutovalidateMode.onUserInteraction,
                                          maxLength: CreateCertificateController
                                              .maxDocumentNumberLength,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[a-zA-Z0-9]'),
                                            ),
                                            LengthLimitingTextInputFormatter(
                                              CreateCertificateController
                                                  .maxDocumentNumberLength,
                                            ),
                                          ],
                                          onValueChange: (_) {},
                                          validator: MultiValidator([
                                            RequiredValidator(
                                              errorText: 'required_field'.tr,
                                            ),
                                            PatternValidator(
                                              r'^[a-zA-Z0-9]+$',
                                              errorText:
                                                  'document_number_invalid'.tr,
                                            ),
                                          ]),
                                        ),
                                        Obx(
                                          () => Visibility(
                                            visible:
                                                !controller.isInsuranceType.value,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 24),
                                                PrimaryTextView(
                                                  text: 'upload_file'.tr,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                const SizedBox(height: 10),
                                                CertificateFileUploadView(
                                                  filePath: controller.filePath,
                                                  selectedFileName: controller
                                                      .selectedFileName,
                                                  onUploadTap: controller
                                                      .showAttachmentOptionsDialog,
                                                  onRemove:
                                                      controller.removeFile,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                              margin:
                                  const EdgeInsets.fromLTRB(14, 18, 14, 16),
                              buttonText: 'save_document'.tr,
                              onPressed: controller.onSavePressed,
                            ),
                          ],
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
