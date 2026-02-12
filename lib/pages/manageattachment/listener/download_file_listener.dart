abstract class DownloadFileListener {
  void onDownload({required int progress, required String action});

  void afterDownload({required String filaPath, required String action});
}
