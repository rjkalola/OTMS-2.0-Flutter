import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/listener/date_filter_listener.dart';
import 'package:otm_inventory/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:otm_inventory/pages/project/check_in_records/view/widgets/project_address_title_view.dart';
import 'package:otm_inventory/pages/project/trade_records/controller/trade_records_controller.dart';
import 'package:otm_inventory/pages/project/trade_records/view/widgets/trade_user_records.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/toolbar_menu_item_text_view.dart';

class TradeRecordsScreen extends StatefulWidget {
  const TradeRecordsScreen({super.key});

  @override
  State<TradeRecordsScreen> createState() => _TradeRecordsScreenState();
}

class _TradeRecordsScreenState extends State<TradeRecordsScreen>
    implements DateFilterListener {
  final controller = Get.put(TradeRecordsController());

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
              title: 'trades'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
              widgets: actionButtons(),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          // controller.getUserListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            ProjectAddressTitleView(
                                title: controller.title.value),
                            SizedBox(height: 2,),
                            PrimaryTextView(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              text:
                                  "${controller.displayStartDate.value} - ${controller.displayEndDate.value}",
                            ),
                            SizedBox(height: 10,),
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
                            TradeUserRecords(),
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: controller.isResetEnable.value,
        child: ToolbarMenuItemTextView(
          text: 'reset'.tr,
          padding: EdgeInsets.only(left: 6, right: 10),
          onTap: () {
            controller.clearFilter();
          },
        ),
      ),
      /* InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          List<ModuleInfo> listItems = [];
          for (var info in DataUtils.getWeekDays()) {
            listItems.add(ModuleInfo(
                name: StringHelper.capitalizeFirstLetter(info.name)));
          }
          controller.showMenuItemsDialog(context, listItems,
              AppConstants.dialogIdentifier.selectDayFilter);
        },
        child: Padding(
          padding: EdgeInsets.all(2),
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.filterIcon,
              width: 26,
              height: 26,
              color: primaryTextColor_(context)),
        ),
      ),
      IconButton(
        icon: Icon(Icons.more_vert_outlined),
        onPressed: () {
          // controller.showMenuItemsDialog(Get.context!);
        },
      ),*/
    ];
  }

  @override
  void onSelectDateFilter(
      String startDate, String endDate, String dialogIdentifier) {
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getProjectTradeRecordsApi(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
