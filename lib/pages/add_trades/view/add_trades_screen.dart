import 'package:belcka/pages/add_trades/controller/add_trades_controller.dart';
import 'package:belcka/pages/add_trades/view/widgets/category_select_view.dart';
import 'package:belcka/pages/add_trades/view/widgets/trade_name_text_field.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddTradesScreen extends StatefulWidget {
  const AddTradesScreen({super.key});

  @override
  State<AddTradesScreen> createState() => _AddTradesScreenState();
}

class _AddTradesScreenState extends State<AddTradesScreen> {
  final controller = Get.put(AddTradesController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "add_trade".tr,
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
                ? Center(
              child: Text("no_internet_text".tr),
            )
                : SingleChildScrollView(
                child: CardViewDashboardItem(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TradeNameTextField(controller: controller.tradeNameController,
                      isEnabled: true,),
                      // Trade field
                      SizedBox(height: 16),
                      CategorySelectView(),
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.onSubmit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: defaultAccentColor_(context),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('submit'.tr,
                              style: TextStyle(
                                  color:Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          // This is where bottomNavigationBar should go

        ),
      ),
    )
    );
  }
}
