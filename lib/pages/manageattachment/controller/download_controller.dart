import 'package:belcka/pages/manageattachment/listener/download_file_listener.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/download_save_path.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController {
  final progress = 0.obs;
  final isDownloading = false.obs;

  Future<void> downloadFile(String url, String fileName,
      {String? downloadSuccessMessage, DownloadFileListener? listener}) async {
    print("url:"+url);
    try {
      isDownloading.value = true;
      progress.value = 0;

      final savePath = await resolveDownloadSavePath(fileName);
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
      print("Error:"+e.toString());
      isDownloading.value = false;
      AppUtils.showToastMessage('download_failed'.tr);
    }
  }
}
