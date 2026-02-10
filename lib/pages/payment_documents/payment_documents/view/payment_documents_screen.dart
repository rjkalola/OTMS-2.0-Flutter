import 'package:belcka/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/document_footer_buttons_view.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/header_tab_view.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/invoice_date_list.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/payslip_date_list.dart';
import 'package:belcka/pages/payment_documents/payment_documents/view/widgets/select_all_documents.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../utils/app_constants.dart';

class PaymentDocumentsScreen extends StatefulWidget {
  const PaymentDocumentsScreen({super.key});

  @override
  State<PaymentDocumentsScreen> createState() => _PaymentDocumentsScreenState();
}

class _PaymentDocumentsScreenState extends State<PaymentDocumentsScreen>
    implements DateFilterListener {
  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || result != null) return;
          controller.onBackPress();
        },
        child: Container(
            color: backgroundColor_(context),
            child: SafeArea(
              child: Scaffold(
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: 'documents'.tr,
                  isCenterTitle: false,
                  bgColor: backgroundColor_(context),
                  isBack: true,
                  widgets: (controller.isDownloadEnable.value ||
                          controller.isDeleteEnable.value)
                      ? []
                      : actionButtons(),
                  onBackPressed: () {
                    controller.onBackPress();
                  },
                  isSearching: controller.isSearchEnable.value,
                  searchController: controller.searchController,
                  onValueChange: (value) {
                    controller.searchItems(value);
                  },
                  autoFocus: true,
                  isClearVisible: false.obs,
                ),
                backgroundColor: dashBoardBgColor_(context),
                body: ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            controller.isInternetNotAvailable.value = false;
                            // controller.getTeamListApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderTabView(),
                                const SizedBox(height: 16),
                                (controller.isDownloadEnable.value ||
                                        controller.isDeleteEnable.value)
                                    ? SelectAllDocuments()
                                    : DateFilterOptionsHorizontalList(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        startDate: controller.startDate,
                                        endDate: controller.endDate,
                                        listener: this,
                                        selectedPosition:
                                            controller.selectedDateFilterIndex,
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                setSelectedWidget(),
                                const SizedBox(height: 16),
                                DocumentFooterButtonsView()
                              ],
                            ),
                          )),
                ),
                bottomNavigationBar: CommonBottomNavigationBarWidget(),
              ),
            ))));
  }

  Widget setSelectedWidget() {
    if (controller.selectedFilter.value.tr == AppConstants.action.invoices) {
      return InvoiceDateList(
          searchText: controller.searchController.value.text);
    } else if (controller.selectedFilter.value.tr ==
        AppConstants.action.payslips) {
      return PayslipDateList(
          searchText: controller.searchController.value.text);
    } else {
      return Container();
    }
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible:
            controller.selectedFilter.value != AppConstants.action.payments,
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            if (controller.selectedFilter.value ==
                AppConstants.action.invoices) {
              var arguments = {
                AppConstants.intentKey.userId: UserUtils.getLoginUserId() ?? 0,
              };
              controller.moveToScreen(AppRoutes.addInvoiceScreen, arguments);
            } else if (controller.selectedFilter.value ==
                AppConstants.action.payslips) {
              var arguments = {
                AppConstants.intentKey.userId: UserUtils.getLoginUserId() ?? 0,
              };
              controller.moveToScreen(AppRoutes.addPayslipScreen, arguments);
            }
            // controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
      Visibility(
        visible:
            controller.selectedFilter.value != AppConstants.action.payments,
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      )
    ];
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    // TODO: implement onSelectDateFilter
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      controller.clearFilter();
    }
    controller.loadData(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
