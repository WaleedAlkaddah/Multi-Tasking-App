import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:quick_log/quick_log.dart';
import 'package:work_task/controller/excel_con1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../waleed_widget/flutter_toast.dart';

class FileController extends GetxController {
  final TextEditingController fileNameReadController = TextEditingController();
  final TextEditingController fileNameWriteController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String filePath = "";
  String content = " ";
    final log = const Logger("FileController");

  static Future<bool> requestStoragePermission() async {
    // OS or above 13 is Permission.manageExternalStorage.request();
    // OS Under 13 is Permission.storage.request()
    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }

  Future<void> writeToFile(String fileName, String content) async {
    if (await requestStoragePermission()) {
      filePath =
          await ExcelController1().getExternalStorageDirectoryFunc(fileName);
      File file = File(filePath);
      String oldContent = await readFromFile(fileName);
      String newContent = "$oldContent\n$content";
      await file.writeAsString(newContent);
      log.info("File written successfully: $filePath", includeStackTrace: false);
      FlutterToastWidget.buildFlutterToast(
          "File written successfully: $filePath");
    } else {
      log.error("Storage permission is not granted", includeStackTrace: false);
      FlutterToastWidget.buildFlutterToast("Storage permission is not granted");
    }
    update();
  }

  Future<String> readFromFile(String fileName) async {
    if (await requestStoragePermission()) {
      filePath =
          await ExcelController1().getExternalStorageDirectoryFunc(fileName);
      try {
        File file = File(filePath);
        content = await file.readAsString();
        FlutterToastWidget.buildFlutterToast("Read From File");
        update();
        return content;
      } catch (e) {
        return "";
      }
    } else {
      FlutterToastWidget.buildFlutterToast("Storage permission is not granted");
      log.error("Storage permission is not granted", includeStackTrace: false);
      update();
      return "Storage permission not granted";
    }
  }

  void onPressedRead() async {
    String content = await readFromFile(fileNameReadController.text);
    log.info(content, includeStackTrace: false);
    update();
  }

  void onPressedWrite() async {
    await writeToFile(fileNameWriteController.text, contentController.text);
    update();
  }
}
