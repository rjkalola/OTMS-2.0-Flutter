import 'package:belcka/buyer_app/stores/add_store/controller/buyer_add_store_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BuyerAddStoreScreen extends StatefulWidget {
  const BuyerAddStoreScreen({super.key});

  @override
  State<BuyerAddStoreScreen> createState() => _BuyerAddStoreScreenState();
}

class _BuyerAddStoreScreenState extends State<BuyerAddStoreScreen> {
  final controller = Get.put(BuyerAddStoreController());

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
                  ? 'update_store'.tr
                  : 'add_store'.tr,
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
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
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
                                                      .showPhoneExtensionDialog();
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
                                              maxLength: 15,
                                              keyboardType: TextInputType.phone,
                                              textInputAction:
                                                  TextInputAction.next,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              onValueChange: (value) {
                                                controller.isSaveEnable.value =
                                                    true;
                                              },
                                              validator: MultiValidator([]),
                                            ),
                                          ),
                                        ],
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
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFieldBorderDark(
                                        textEditingController:
                                            controller.addressController.value,
                                        hintText: 'address'.tr,
                                        labelText: 'address'.tr,
                                        isReadOnly: false,
                                        maxLength: 200,
                                        keyboardType:
                                            TextInputType.streetAddress,
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
                                        textEditingController: controller
                                            .storeManagerController.value,
                                        hintText: 'store_manager'.tr,
                                        labelText: 'store_manager'.tr,
                                        isReadOnly: true,
                                        keyboardType: TextInputType.name,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        suffixIcon:
                                            const Icon(Icons.arrow_drop_down),
                                        onPressed: () {
                                          controller
                                              .showSelectStoreManagerDialog();
                                        },
                                        validator: MultiValidator([]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
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
                                controller.addOrUpdateStoreApi();
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
