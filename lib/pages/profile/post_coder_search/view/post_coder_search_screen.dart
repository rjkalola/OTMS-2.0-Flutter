import 'package:belcka/pages/profile/post_coder_search/view/search_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/post_coder_search/controller/post_coder_search_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import '../../../../widgets/textfield/text_field_underline_.dart';

class PostCoderSearchScreen extends StatefulWidget {
  @override
  _PostCoderSearchScreenState createState() => _PostCoderSearchScreenState();
}

class _PostCoderSearchScreenState extends State<PostCoderSearchScreen> {
  final controller = Get.put(PostCoderSearchController());
  void _search() {
    FocusScope.of(context).unfocus();
    final txt = controller.postCodeFieldController.value.text.trim();
    if (txt.isNotEmpty) {
      controller.lookupAddress(txt);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: "search_post_code".tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
            ),
            backgroundColor: dashBoardBgColor_(context),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? Center(child: Text("no_internet_text".tr))
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchTextFieldWidget(controller: controller.postCodeFieldController),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 40),
                        backgroundColor: defaultAccentColor_(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Text(
                        'search'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.headerText.isNotEmpty)
                      Text(
                        controller.headerText.value,
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.addressList.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = controller.addressList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.back(result: {
                                "summaryline": item.summaryline ?? "",
                                "postcode": item.postcode ?? "",
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0),
                              child: Text(item.summaryline ?? "",),
                            ),
                          );
                        },
                      ),
                    ),
                    if (controller.nextPage.value > 0)
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            //controller.loadNextPage(_controller.text);
                          },
                          child: Text(
                            "Next page",
                            style: TextStyle(
                                color: defaultAccentColor_(context)),
                          ),
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