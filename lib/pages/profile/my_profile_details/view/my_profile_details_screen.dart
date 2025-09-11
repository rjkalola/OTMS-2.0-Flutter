import 'package:belcka/pages/profile/billing_details_new/view/widgets/info_card.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/no_billing_data_view.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/pending_for_approval_view.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/title_text.dart';
import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/email_field_widget.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/name_field_widget.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/phone_field_widget.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/profile_avatar_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../utils/app_constants.dart';


class MyProfileDetailsScreen extends StatefulWidget {
  const MyProfileDetailsScreen({super.key});

  @override
  State<MyProfileDetailsScreen> createState() => _MyProfileDetailsScreenState();
}

class _MyProfileDetailsScreenState extends State<MyProfileDetailsScreen> {
  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'my_account'.tr,
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
                ?  Center(
              child: Text('no_internet_text'.tr),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //profile UI
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar
                                    ProfileAvatarWidget(),
                                    SizedBox(height: 10),
                                    // trade
                                    Text(
                                      controller.myProfileInfo.value.tradeName ?? "",
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10),
                                    CardViewDashboardItem(
                                        margin: EdgeInsets.fromLTRB(4, 6, 4, 6),
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TitleText(
                                                title: 'general'.tr,
                                              ),
                                              NameFieldWidget(),
                                              PhoneFieldWidget(),
                                              EmailFieldWidget(),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                )),
          ),
        ),
      ),
    ),);
  }
}