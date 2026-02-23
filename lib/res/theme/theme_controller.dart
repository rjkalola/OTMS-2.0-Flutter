import 'package:belcka/utils/map_utils.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_storage.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    _loadTheme();
    super.onInit();
  }

  void toggleTheme(bool value) async {
    _isDarkMode.value = value;
    Get.find<AppStorage>().setThemeMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    final controller = Get.put(ThemeController());
    ThemeConfig.isDarkMode = controller.isDarkMode;
    MapUtils.loadMapTheme();
  }

  void _loadTheme() async {
    _isDarkMode.value = Get.find<AppStorage>().getThemeMode();
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
