import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:quick_log/quick_log.dart';
import '../controller/file_con.dart';
import '../waleed_widget/flutter_toast.dart';

class ExcelController1 extends GetxController {
  final TextEditingController fileNameWriteController = TextEditingController();
  final TextEditingController rowsController = TextEditingController();
  final TextEditingController columnsController = TextEditingController();
  int rows = 0;
  int columns = 0;
  bool updateCheck = false;
  String filePath = "";
  final log = const Logger("ExcelController1");
  List<List<String>> tableData = [];
  List<List<String>> data = List.generate(2, (index) => List.filled(2, ""));
  List<List<dynamic>> dataUpdate =
      List.generate(2, (index) => List.filled(2, ""));

  Future<String> getExternalStorageDirectoryFunc(String controllerName) async {
    // OS or above 13 is getExternalStorageDirectory();
    // OS Under 13 is getApplicationDocumentsDirectory();
    Directory? appDocumentsDirectory = await getExternalStorageDirectory();
    filePath = '${appDocumentsDirectory!.path}/$controllerName';
    return filePath;
  }

  Future<void> createExcel() async {
    log.info("File name createExcel : ${fileNameWriteController.text}" , includeStackTrace: false);
    if (await FileController.requestStoragePermission()) {
      Excel excel = Excel.createExcel();
      filePath =
          await getExternalStorageDirectoryFunc(fileNameWriteController.text);
      var file = await File(filePath).create();
      await file.writeAsBytes(excel.encode()!);
      log.fine('Excel file created successfully. $filePath', includeStackTrace: false);
      FlutterToastWidget.buildFlutterToast(
          'Excel file created successfully. $filePath');
      update();
    } else {
      FlutterToastWidget.buildFlutterToast("Storage permission is not granted");
      log.error("Storage permission is not granted", includeStackTrace: false);
      update();
    }
  }

  void deleteExcel() async {
    try {
      if (await FileController.requestStoragePermission()) {
        filePath =
            await getExternalStorageDirectoryFunc(fileNameWriteController.text);
        log.info("deleteExcel() : $filePath", includeStackTrace: false);
        if (await File(filePath).exists()) {
          await File(filePath).delete();
          log.fine("Excel file deleted successfully", includeStackTrace: false);
          fileNameWriteController.text = '';
          rowsController.text = '';
          columnsController.text = '';
          rows = 0;
          columns = 0;
          data.clear();
          tableData.clear();
          dataUpdate.clear();
          FlutterToastWidget.buildFlutterToast(
              "Excel file deleted successfully");
        } else {
          log.error("Excel file not found", includeStackTrace: false);
          FlutterToastWidget.buildFlutterToast("Excel file not found");
        }
        update();
      } else {
        FlutterToastWidget.buildFlutterToast(
            "Storage permission is not granted");
        log.info("Storage permission is not granted", includeStackTrace: false);
        update();
      }
    } catch (e) {
      log.error("Error deleting Excel file: $e", includeStackTrace: false);
      FlutterToastWidget.buildFlutterToast("Error deleting Excel file: $e");
    }
  }

  void displayTable() {
    rows = int.tryParse(rowsController.text) ?? 0;
    data = List.generate(rows, (index) => List.filled(columns, ""));
    columns = int.tryParse(columnsController.text) ?? 0;
    data = List.generate(rows, (index) => List.filled(columns, ""));
    log.info("Rows Number : $rows , Columns Numbers : $columns", includeStackTrace: false);
    update();
  }

  void appendData() async {
    try {
      if (await FileController.requestStoragePermission()) {
        filePath =
            await getExternalStorageDirectoryFunc(fileNameWriteController.text);
        var file = filePath;
        var bytes = File(file).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        var sheet = excel['Sheet1'];
        for (var row in data) {
          sheet.appendRow(row);
        }
        var newFile = filePath;
        var newBytes = excel.save();
        File(newFile).createSync(recursive: true);
        File(newFile).writeAsBytesSync(newBytes!);
        log.info(data, includeStackTrace: false);
        FlutterToastWidget.buildFlutterToast('Data Appended');
        update();
      } else {
        FlutterToastWidget.buildFlutterToast(
            "Storage permission is not granted");
        log.error("Storage permission is not granted", includeStackTrace: false);
        update();
      }
    } catch (e) {
      log.error("Error : $e", includeStackTrace: false);
    }
  }

  Future<void> readExcel() async {
    tableData.clear();
    filePath =
        await getExternalStorageDirectoryFunc(fileNameWriteController.text);
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        tableData
            .add(List<String>.from(row.map((cell) => cell?.value.toString())));
      }
    }
    log.info(tableData, includeStackTrace: false);
    update();
  }

  void updateCell() async {
    try {
      filePath =
          await getExternalStorageDirectoryFunc(fileNameWriteController.text);
      log.info("------------------------", includeStackTrace: false);
      log.info("updateCell : $filePath", includeStackTrace: false);
      log.info(dataUpdate, includeStackTrace: false);
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel["Sheet1"];
      for (int i = 0; i < dataUpdate.length; i++) {
        for (int j = 0; j < dataUpdate[i].length; j++) {
          dynamic value = dataUpdate[i][j];
          if (value is String && value.isNotEmpty) {
            var cell = sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i));
            log.info("Column : $j , row: $i", includeStackTrace: false);
            cell.value = dataUpdate[i][j];
            log.info("cell.value : ${cell.value}", includeStackTrace: false);
          }
        }
      }
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);
      update();
    } catch (e) {
      log.error("Error $e", includeStackTrace: false);
    }
  }

  void callUpdateTable() {
    updateCheck = true;
    update();
  }
}
