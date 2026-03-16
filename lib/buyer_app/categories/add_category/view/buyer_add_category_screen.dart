import 'package:belcka/buyer_app/categories/add_category/controller/add_category_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BuyerAddCategoryScreen extends StatefulWidget {
  const BuyerAddCategoryScreen({super.key});

  @override
  State<BuyerAddCategoryScreen> createState() => _BuyerAddCategoryScreenState();
}

class _BuyerAddCategoryScreenState extends State<BuyerAddCategoryScreen> {
  final controller = Get.put(AddCategoryController());

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
              title: 'add_category'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: [
                Switch(
                  value: controller.isEnabled.value,
                  onChanged: (value) {
                    controller.isEnabled.value = value;
                  },
                  activeColor: Colors.white,
                  activeTrackColor: defaultAccentColor_(context),
                ),
                const SizedBox(width: 10),
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
                        controller.getParentCategoriesApi();
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
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
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
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: DropDownTextField(
                                        title: 'parent_category'.tr,
                                        controller:
                                            controller.parentCategoryController,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value = true;
                                        },
                                        onPressed: () {
                                          controller.showParentCategoryDialog();
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    PrimaryTextView(
                                      text: 'upload_image'.tr,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryTextColor_(context),
                                    ),
                                    const SizedBox(height: 12),
                                    Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            controller
                                                .showAttachmentOptionsDialog();
                                          },
                                          child: controller
                                                  .imageUrl.value.isNotEmpty
                                              ? DocumentView(
                                                  file:
                                                      controller.imageUrl.value,
                                                  width: 160,
                                                  height: 160,
                                                  isEditable: true,
                                                  onRemoveClick: () {
                                                    controller.imageUrl.value =
                                                        "";
                                                  },
                                                )
                                              : Container()
                                          // DottedBorder(
                                          //         color: defaultAccentColor_(context),
                                          //         strokeWidth: 2,
                                          //         dashPattern: const [6, 3],
                                          //         borderType: BorderType.RRect,
                                          //         radius: const Radius.circular(24),
                                          //         child: Container(
                                          //           width: 160,
                                          //           height: 160,
                                          //           alignment: Alignment.center,
                                          //           child: PrimaryTextView(
                                          //             text: 'click_or_drag_image'.tr,
                                          //             fontSize: 14,
                                          //             color: defaultAccentColor_(context),
                                          //           ),
                                          //         ),
                                          //       ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    buttonText: 'save'.tr,
                                    onPressed: () {
                                      if (controller.valid()) {
                                        controller.addCategoryApi();
                                      }
                                    },
                                    color: defaultAccentColor_(context),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      controller.onBackPress();
                                    },
                                    child: PrimaryTextView(
                                      text: 'close'.tr,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryTextColor_(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
