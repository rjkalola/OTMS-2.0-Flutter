import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/user_orders/favorite_popup/add_folder_view.dart';
import 'package:belcka/pages/user_orders/favorites/controller/favorites_controller.dart';
import 'package:belcka/pages/user_orders/project_service/project_folder_response.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesController controller = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
          () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: OrdersBaseAppBar(
                appBar: AppBar(),
                title: 'favorites'.tr,
                isCenterTitle: false,
                isBack: true,
                bgColor: backgroundColor_(context),
                onBackPressed: () {
                  controller.onBackPress();
                },
                onPressedClear: () {

                },
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
                  },
                )
                    : controller.isMainViewVisible.value
                    ? Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: Obx(() {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: controller.projectService.folderList.length + 1,
                            itemBuilder: (context, index) {

                              if (index == controller.projectService.folderList.length) {

                                return Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                                  child: _buildCreateAlbumButton(),
                                );

                              }

                              final album = controller.projectService.folderList[index];
                              return _buildAlbumCard(album);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumCard(ProjectFolderInfo album) {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(Icons.bookmark, color: album.folderColor, size: 20),
          title: Text(album.name ?? '',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 20),
          onTap: () {
            var arguments = {
              "id":album.id,
            };
            controller.moveToScreen(AppRoutes.favoriteProductsScreen, arguments);
          },
        ),
      ),
    );
  }

  Widget _buildCreateAlbumButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: (){
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))
                    ],
                  ),
                  child: AddFolderView(
                    folders: [],
                    onCancel: () => Navigator.pop(context),
                    onAdded: (folderName,projectId) async {
                      Navigator.pop(context);
                      await controller.projectService.toggleCreateNewFolder(folderName,projectId);
                      controller.projectService.folderList.refresh();
                    },

                  ),
                ),
              );
            },
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        icon: const Icon(Icons.add, color: Colors.grey, size: 20),
        label: SubtitleTextView(text:
          'create_a_new_album'.tr,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}