import 'dart:io';

import 'package:belcka/pages/manageattachment/listener/download_file_listener.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  final progress = 0.obs;
  final isDownloading = false.obs;

  Future<void> downloadFile(String url, String fileName,
      {String? downloadSuccessMessage, DownloadFileListener? listener}) async {
    try {
      isDownloading.value = true;
      progress.value = 0;

      String savePath;
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;
        if (sdkInt <= 29) {
          final status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }
        }
        // await Permission.storage.request();
        savePath = "/storage/emulated/0/Download/$fileName";
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = "${dir.path}/$fileName";
      }
      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = ((received / total) * 100).toInt();
            if (listener != null) {
              listener.onDownload(progress: progress.value, action: "");
            }
            print("progress.value:" + progress.value.toString());
          }
        },
      );
      isDownloading.value = false;
      if (listener != null) {
        listener.afterDownload(filaPath: savePath, action: "");
      }else{
        AppUtils.showToastMessage(downloadSuccessMessage ?? 'file_downloaded'.tr);
      }
      // OpenFilex.open(savePath);
    } catch (e) {
      isDownloading.value = false;
      AppUtils.showToastMessage('download_failed'.tr);
    }
  }
}
