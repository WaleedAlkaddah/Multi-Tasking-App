import 'package:get/get.dart';
import 'package:work_task/controller/excel_con1.dart';
import 'package:work_task/controller/file_con.dart';

class FileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FileController>(() => FileController());
    Get.lazyPut<ExcelController1>(() => ExcelController1());
  }
}
