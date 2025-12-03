import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/bank_details_view.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/general_view.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/tax_info_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class BillingInfoScreen extends StatefulWidget {
  const BillingInfoScreen({super.key});

  @override
  State<BillingInfoScreen> createState() => _BillingInfoScreenState();
}

class _BillingInfoScreenState extends State<BillingInfoScreen> {
  final controller = Get.put(BillingInfoController());

  KeyboardActionsConfig _buildKeyboardConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: controller.focusNode,
          toolbarButtons: [
            (node) => TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'done'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ModalProgressHUD(
        inAsyncCall: controller.isLoading.value,
        opacity: 0.3,
        progressIndicator: const CustomProgressbar(),
        child: Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'billing_info'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
              ),
              backgroundColor: dashBoardBgColor_(context),

              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                onPanDown: (_) => FocusScope.of(context).unfocus(),
                child: KeyboardActions(
                  config: _buildKeyboardConfig(),
                  child: controller.isInternetNotAvailable.value
                      ? Center(child: Text("no_internet_text".tr))
                      : SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GeneralView(),
                          TaxInfoView(),
                          BankDetailsView(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              bottomNavigationBar: SafeArea(
                child: Visibility(
                  visible: controller.isShowSaveButton.value,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      final enabled = controller.isSaveEnabled.value;
                      return Opacity(
                        opacity: enabled ? 1.0 : 0.5,
                        child: ElevatedButton(
                          onPressed: enabled ? controller.onSubmit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: defaultAccentColor_(context),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'save'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
