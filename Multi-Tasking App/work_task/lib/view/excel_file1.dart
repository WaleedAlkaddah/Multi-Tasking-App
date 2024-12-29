import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/excel_con1.dart';
import '../waleed_widget/elevated_button.dart';
import '../waleed_widget/text_field.dart';

class ExcelFile1 extends StatefulWidget {
  const ExcelFile1({super.key});

  @override
  State<ExcelFile1> createState() => _ExcelFile1State();
}

class _ExcelFile1State extends State<ExcelFile1> {
  final ExcelController1 controller = Get.find<ExcelController1>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExcelController1>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Excel Writer'),
          actions: [
            ElevatedBtn(
                url: "",
                name: "Delete Excel",
                onPressedCall: () => controller.deleteExcel()),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                TextFieldModified(
                    controller: controller.fileNameWriteController,
                    text: "File Name"),
                const SizedBox(height: 20),
                ElevatedBtn(
                    url: "",
                    name: "Create Excel",
                    onPressedCall: () => controller.createExcel()),
                const SizedBox(height: 20),
                const Divider(
                  thickness: 5,
                ),
                const Text(
                  "Choose Number of Row and Columns For Append",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFieldModified(
                    controller: controller.rowsController, text: "Row:"),
                const SizedBox(width: 20),
                TextFieldModified(
                    controller: controller.columnsController, text: "Columns:"),
                const SizedBox(height: 20),
                ElevatedBtn(
                    url: "",
                    name: "Done",
                    onPressedCall: () => controller.displayTable()),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  width: 300,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: controller.rows,
                      itemBuilder: (context, rowIndex) {
                        return Row(
                            children:
                                List.generate(controller.columns, (colIndex) {
                          return Flexible(
                            child: TextFieldModified(
                              onChanged: (value) {
                                controller.data[rowIndex][colIndex] = value;
                              },
                              border: const OutlineInputBorder(),
                            ),
                          );
                        }));
                      }),
                ),
                const SizedBox(height: 20),
                ElevatedBtn(
                    url: "",
                    name: "Append Excel file",
                    onPressedCall: () => controller.appendData()),
                const SizedBox(height: 20),
                const Divider(
                  thickness: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedBtn(
                        url: "",
                        name: " Append Update",
                        onPressedCall: () => controller.updateCell()),
                    const SizedBox(height: 12),
                    ElevatedBtn(
                        url: "",
                        name: "Read Excel file",
                        onPressedCall: () => controller.readExcel()),
                    const SizedBox(height: 12),
                   
                  ],
                ),
                 ElevatedBtn(
                        url: "",
                        name: "Update",
                        onPressedCall: () => controller.callUpdateTable()),
                const Divider(
                  thickness: 5,
                ),
                if (controller.updateCheck)
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: controller.rows,
                      itemBuilder: (context, rowIndex) {
                        return Row(
                          children:
                              List.generate(controller.columns, (colIndex) {
                            return Flexible(
                              child: TextFormField(
                                initialValue: controller.tableData[rowIndex]
                                    [colIndex],
                                onChanged: (value) {
                                  controller.dataUpdate[rowIndex][colIndex] =
                                      value;
                                },
                                decoration:const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                if (controller.tableData.isEmpty)
                 const CircularProgressIndicator()
                else
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: ListView.builder(
                      itemCount: controller.tableData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(controller.tableData[index].join(', ')),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
