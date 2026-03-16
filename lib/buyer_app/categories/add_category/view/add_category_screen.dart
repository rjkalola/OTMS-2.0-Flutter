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
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
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
                  : Column(
                      children: [
                        Expanded(
                          child: Form(
                            key: controller.formKey,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 24),
                                    PrimaryTextView(
                                      text: 'name'.tr,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(height: 8),
                                    TextFieldBorder(
                                      textEditingController: controller.nameController.value,
                                      hintText: 'enter_category_name'.tr,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next
                                    ),
                                    const SizedBox(height: 24),
                                    PrimaryTextView(
                                      text: 'parent_category'.tr,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(height: 8),
                                    DropDownTextField(
                                      title: 'select_parent_category'.tr,
                                      controller: controller.parentCategoryController,
                                      onPressed: () {
                                        controller.showParentCategoryDialog();
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    // Attachment section copied from AddInvoiceScreen
                                    PrimaryTextView(
                                      text: 'attachment'.tr,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        controller.showAttachmentOptionsDialog();
                                      },
                                      child: DocumentView(
                                        onRemoveClick: () {
                                          controller.imageUrl.value = "";
                                        },
                                        isEditable: true,
                                        fileRadius: 0,
                                        width: 100,
                                        height: 100,
                                        file: controller.imageUrl.value,
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }
}
