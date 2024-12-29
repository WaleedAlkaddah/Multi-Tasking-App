import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/file_con.dart';
import '../waleed_widget/text_field.dart';
import '../text/text.dart';
import '../waleed_widget/elevated_button.dart';

class ReadWriteFile extends StatefulWidget {
  const ReadWriteFile({super.key});

  @override
  State<ReadWriteFile> createState() => _ReadWriteFileState();
}

class _ReadWriteFileState extends State<ReadWriteFile> {
  final FileController fileController = Get.find<FileController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FileController>(builder: (fileController) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(TextView.files),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldModified(
                    controller: fileController.fileNameReadController,
                    text: TextView.readFile),
                ElevatedBtn(
                    url: "",
                    name: TextView.read,
                    onPressedCall: () => fileController.onPressedRead()),
                Text("Content : ${fileController.content}"),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  TextView.write,
                  style: TextStyle(fontSize: 20),
                ),
                TextFieldModified(
                    controller: fileController.fileNameWriteController,
                    text: TextView.nameFile),
                TextFieldModified(
                    controller: fileController.contentController,
                    text: TextView.enterContent),
                const SizedBox(height: 16),
                ElevatedBtn(
                    url: "",
                    name: TextView.write,
                    onPressedCall: () => fileController.onPressedWrite()),
              ],
            ),
          ),
        ),
      );
    });
  }
}
