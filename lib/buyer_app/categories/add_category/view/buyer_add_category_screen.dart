import 'package:belcka/buyer_app/categories/add_category/controller/buyer_add_category_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/image/document_view.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
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
  final controller = Get.put(BuyerAddCategoryController());

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
                  ? 'update_category'.tr
                  : 'add_category'.tr,
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
                                        textInputAction: TextInputAction.done,
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
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 14),
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
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
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
                                                    !(controller.status.value);
                                              },
                                              mValue: controller.status.value),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PrimaryButton(
                            margin: EdgeInsets.all(14),
                            buttonText: 'save'.tr,
                            onPressed: () {
                              if (controller.valid() &&
                                  controller.isSaveEnable.value) {
                                controller.addCategoryApi();
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
