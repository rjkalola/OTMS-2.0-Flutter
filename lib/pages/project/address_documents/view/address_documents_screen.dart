import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/project/address_documents/controller/address_documents_controller.dart';
import 'package:belcka/pages/project/address_documents/view/widgets/address_documents.dart';
import 'package:belcka/pages/project/check_in_records/view/widgets/project_address_title_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddressDocumentsScreen extends StatefulWidget {
  const AddressDocumentsScreen({super.key});

  @override
  State<AddressDocumentsScreen> createState() => _AddressDocumentsScreenState();
}

class _AddressDocumentsScreenState extends State<AddressDocumentsScreen>
    implements DateFilterListener {
  final controller = Get.put(AddressDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'documents'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getAddressDocumentsApi(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            ProjectAddressTitleView(
                                title: controller.title.value),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // PrimaryTextView(
                            //   fontWeight: FontWeight.w500,
                            //   fontSize: 15,
                            //   text:
                            //       "${controller.displayStartDate.value} - ${controller.displayEndDate.value}",
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            DateFilterOptionsHorizontalList(
                              padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                              startDate: controller.startDate,
                              endDate: controller.endDate,
                              listener: this,
                              selectedPosition:
                                  controller.selectedDateFilterIndex,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AddressDocuments(),
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  @override
  void onSelectDateFilter(
      int filterIndex, String filter,String startDate, String endDate, String dialogIdentifier) {
    controller.startDate = startDate;
    controller.endDate = endDate;
    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      controller.clearFilter();
    }
    controller.getAddressDocumentsApi(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
