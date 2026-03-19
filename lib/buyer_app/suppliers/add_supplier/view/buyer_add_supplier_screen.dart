import 'package:belcka/buyer_app/suppliers/add_supplier/controller/buyer_add_supplier_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/phone_length_formatter.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';
import 'package:belcka/widgets/validator/custom_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BuyerAddSupplierScreen extends StatefulWidget {
  const BuyerAddSupplierScreen({super.key});

  @override
  State<BuyerAddSupplierScreen> createState() => _BuyerAddSupplierScreenState();
}

class _BuyerAddSupplierScreenState extends State<BuyerAddSupplierScreen> {
  final controller = Get.put(BuyerAddSupplierController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.itemDetails != null
                  ? 'update_supplier'.tr
                  : 'add_supplier'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: [
                controller.itemDetails != null
                    ? GestureDetector(
                        onTap: () {
                          controller.showDeleteDialog();
                        },
                        child: ImageUtils.setSvgAssetsImage(
                            path: Drawable.deleteIcon,
                            color: Colors.red,
                            width: 24,
                            height: 24),
                      )
                    : Container(),
                SizedBox(
                  width: 12,
                )
              ],
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
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Column(
                        children: [
                          Expanded(
                            child: Form(
                              key: controller.formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController:
                                            controller.nameController.value,
                                        hintText: 'name'.tr,
                                        labelText: 'name'.tr,
                                        isReadOnly: false,
                                        maxLength: 50,
                                        keyboardType: TextInputType.name,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: 'required_field'.tr),
                                        ]),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController:
                                            controller.emailController.value,
                                        hintText: 'email'.tr,
                                        labelText: 'email'.tr,
                                        isReadOnly: false,
                                        maxLength: 100,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([
                                          EmailValidator(
                                              errorText:
                                                  'enter_valid_email_address'
                                                      .tr),
                                        ]),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController: controller
                                            .companyNameController.value,
                                        hintText: 'company_name'.tr,
                                        labelText: 'company_name'.tr,
                                        isReadOnly: false,
                                        maxLength: 100,
                                        keyboardType: TextInputType.name,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController: controller
                                            .accountNumberController.value,
                                        hintText: 'account_number'.tr,
                                        labelText: 'account_number'.tr,
                                        isReadOnly: false,
                                        maxLength: 50,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Obx(
                                              () =>
                                                  TextFieldPhoneExtensionWidget(
                                                mExtension: controller
                                                    .phoneExtension.value,
                                                mFlag:
                                                    controller.phoneFlag.value,
                                                onPressed: () {
                                                  controller
                                                      .showPhoneExtensionDialog(
                                                          isContactPerson:
                                                              false);
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            flex: 3,
                                            child: TextFieldBorderDark(
                                              textEditingController: controller
                                                  .phoneController.value,
                                              hintText: 'phone_number'.tr,
                                              labelText: 'phone_number'.tr,
                                              isReadOnly: false,
                                              maxLength: 10,
                                              keyboardType: TextInputType.phone,
                                              textInputAction:
                                                  TextInputAction.next,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              onValueChange: (value) {
                                                controller.isSaveEnable.value =
                                                    true;
                                              },
                                              validator: MultiValidator([
                                                CustomFieldValidator(
                                                  (value) =>
                                                      value == null ||
                                                      value.trim().isEmpty ||
                                                      value.trim().length == 10,
                                                  errorText:
                                                      'error_phone_number_contain_10_digits'
                                                          .tr,
                                                ),
                                              ]),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                                PhoneLengthFormatter(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // const SizedBox(height: 24),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 20),
                                    //   child: PrimaryTextView(
                                    //     text: 'contact_person_details'.tr,
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController: controller
                                            .contactPersonNameController.value,
                                        hintText: 'contact_person_name'.tr,
                                        labelText: 'contact_person_name'.tr,
                                        isReadOnly: false,
                                        maxLength: 50,
                                        keyboardType: TextInputType.name,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController: controller
                                            .contactPersonEmailController.value,
                                        hintText: 'contact_person_email'.tr,
                                        labelText: 'contact_person_email'.tr,
                                        isReadOnly: false,
                                        maxLength: 100,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([
                                          EmailValidator(
                                              errorText:
                                                  'enter_valid_email_address'
                                                      .tr),
                                        ]),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Obx(
                                              () =>
                                                  TextFieldPhoneExtensionWidget(
                                                mExtension: controller
                                                    .contactPersonExtension
                                                    .value,
                                                mFlag: controller
                                                    .contactPersonFlag.value,
                                                onPressed: () {
                                                  controller
                                                      .showPhoneExtensionDialog(
                                                          isContactPerson:
                                                              true);
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            flex: 3,
                                            child: TextFieldBorderDark(
                                              textEditingController: controller
                                                  .contactPersonPhoneController
                                                  .value,
                                              hintText:
                                                  'contact_person_phone'.tr,
                                              labelText:
                                                  'contact_person_phone'.tr,
                                              isReadOnly: false,
                                              maxLength: 10,
                                              keyboardType: TextInputType.phone,
                                              textInputAction:
                                                  TextInputAction.next,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              onValueChange: (value) {
                                                controller.isSaveEnable.value =
                                                    true;
                                              },
                                              validator: MultiValidator([
                                                CustomFieldValidator(
                                                  (value) =>
                                                      value == null ||
                                                      value.trim().isEmpty ||
                                                      value.trim().length == 10,
                                                  errorText:
                                                      'error_phone_number_contain_10_digits'
                                                          .tr,
                                                ),
                                              ]),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                                PhoneLengthFormatter(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController:
                                            controller.streetController.value,
                                        hintText: 'street'.tr,
                                        labelText: 'street'.tr,
                                        isReadOnly: false,
                                        maxLength: 100,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController:
                                            controller.locationController.value,
                                        hintText: 'location'.tr,
                                        labelText: 'location'.tr,
                                        isReadOnly: false,
                                        maxLength: 100,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController:
                                            controller.townController.value,
                                        hintText: 'town'.tr,
                                        labelText: 'town'.tr,
                                        isReadOnly: false,
                                        maxLength: 100,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController:
                                            controller.postcodeController.value,
                                        hintText: 'postcode'.tr,
                                        labelText: 'postcode'.tr,
                                        isReadOnly: false,
                                        maxLength: 20,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: PrimaryTextView(
                                        text: 'upload_photo'.tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 14),
                                      child: InkWell(
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
                                          file: controller.imageUrl.value,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Divider(
                                        color: dividerColor_(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 9, 12, 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: PrimaryTextView(
                                            fontSize: 16,
                                            text: 'status'.tr,
                                          )),
                                          CustomSwitch(
                                              onValueChange: (value) {
                                                controller.isSaveEnable.value =
                                                    true;
                                                controller.status.value =
                                                    !controller.status.value;
                                              },
                                              mValue: controller.status.value),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PrimaryButton(
                            margin: const EdgeInsets.all(14),
                            buttonText: 'save'.tr,
                            onPressed: () {
                              if (controller.valid() &&
                                  controller.isSaveEnable.value) {
                                controller.addOrUpdateSupplierApi();
                              }
                            },
                            color: controller.isSaveEnable.value
                                ? defaultAccentColor_(context)
                                : defaultAccentLightColor_(context),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
