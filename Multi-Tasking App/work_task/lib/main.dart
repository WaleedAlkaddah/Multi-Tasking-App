import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_task/view/first_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [GetPage(name: "/", page: () => const FirstView())],
      debugShowCheckedModeBanner: false,
    );
  }
}
