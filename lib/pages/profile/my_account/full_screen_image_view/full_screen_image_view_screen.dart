import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/profile/my_account/full_screen_image_view/full_screen_image_view_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FullScreenImageViewScreen extends StatefulWidget {
  final String imageUrl;
  final bool? isLoginUser;

  FullScreenImageViewScreen(
      {Key? key, required this.imageUrl, this.isLoginUser})
      : super(key: key);

  @override
  State<FullScreenImageViewScreen> createState() =>
      _FullScreenImageViewScreenState();
}

class _FullScreenImageViewScreenState extends State<FullScreenImageViewScreen> {
  final controller = Get.put(FullScreenImageViewController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: "",
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
              widgets: [
                Visibility(
                  visible: widget.isLoginUser ?? false,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      controller.showAttachmentOptionsDialog();
                    },
                  ),
                )
              ],
            ),
            backgroundColor: dashBoardBgColor_(context),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? Center(
                      child: Text('no_internet_text'.tr),
                    )
                  : InteractiveViewer(
                      panEnabled: true,
                      minScale: 1,
                      maxScale: 4,
                      child: SizedBox.expand(
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                                color: Colors.blue,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.image, color: Colors.grey,size: 100,),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
