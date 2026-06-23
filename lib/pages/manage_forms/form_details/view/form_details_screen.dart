import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/form_entry_fields_list.dart';
import 'package:belcka/pages/manageattachment/controller/download_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/downloading_widget.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FormDetailsScreen extends StatefulWidget {
  const FormDetailsScreen({super.key});

  @override
  State<FormDetailsScreen> createState() => _FormDetailsScreenState();
}

class _FormDetailsScreenState extends State<FormDetailsScreen> {
  final controller = Get.put(FormDetailsController());
  final downloadController = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          bottom: !GetPlatform.isIOS,
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.screenTitle.value,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
              widgets: _actionButtons(),
            ),
            body: Stack(
              children: [
                ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            controller.isInternetNotAvailable.value = false;
                            controller.fetchFormDetail();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: FormEntryFieldsList(),
                        ),
                ),
                if (downloadController.isDownloading.value)
                  DownloadLoader(progress: downloadController.progress.value),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? _actionButtons() {
    return [
      Obx(
        () => Visibility(
          visible: controller.canDownloadPdf,
          child: IconButton(
            icon: Icon(
              Icons.download_outlined,
              color: primaryTextColor_(context),
            ),
            onPressed: () =>
                controller.downloadSubmissionPdf(downloadController),
          ),
        ),
      ),
    ];
  }
}
