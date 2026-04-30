import 'dart:io';

import 'package:myapp/config/data/dio/dio_client.dart';
import 'package:layer_kit/layer_kit.dart';

import '../../di_container.dart';
import '../utils/devlog.dart';

enum FileDownloadFolder {
  miodealSeller("Miodeal Seller"),
  ;

  final String title;

  const FileDownloadFolder(this.title);
}

class FileDownloader {
  const FileDownloader._();

  static Future<void> download(
      {required String downloadUrl,
      FileDownloadFolder? folder,
      required String fileName}) async {
    // final downloadUrlDemo = "https://exams.nta.ac.in/CMAT/images/Information-Bulletin-of-CMAT-2025-14112024.pdf";
    const downloadDirPath = "/storage/emulated/0/Download/";
    final downloadDir = Directory(downloadDirPath);
    if (!(await downloadDir.exists())) {
      await downloadDir.create();
    }
    final extension = downloadUrl.split('.').lastOrNull;
    final dateTime = DateTime.now();
    final fileNamePath =
        "${folder ?? FileDownloadFolder.miodealSeller.title}/$fileName ${dateTime.millisecondsSinceEpoch}.$extension";
    // final notificationDisplayPath = "Download/$fileNamePath";
    final fileSavePath = "$downloadDirPath$fileNamePath";
    devlog("DOWNLOADING TO $fileSavePath");
    try {
      await Di.sl<DioClient>().download(downloadUrl, fileSavePath,
          onReceiveProgress: ((count, total) async {
        await Future.delayed(1.seconds, () {
          final currentProgress = ((count / total) * 100).round();
          const maxProgress = 100;
          if (currentProgress == maxProgress) {
            /// IMPORT LOCAL NOTIFICATIONS INTO PROJECT TO DISPLAY DOWNLOAD PROCESS IN NOTIFICATIONS
            /// TODO : ADD YOUR OWN PROGRESS INDICATOR HERE
            // LocalNotification.cancel(LocalNotifId.progress);
            // LocalNotification.showInstantNotification(title: "Download Completed", body: "Saved in $notificationDisplayPath");
          } else {
            // LocalNotification.showProgressNotification(title: "Downloading $fileName", body: "$currentProgress%", currentProgress: currentProgress, maxProgress: maxProgress);
          }
        });
      }));
    } catch (e) {
      devlogError("DOWNLOADING FILE ERROR : $e");
    }
  }
}
