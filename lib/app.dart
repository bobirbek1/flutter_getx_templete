import 'package:flutter/material.dart';
import 'package:flutter_template/app/app_pages.dart';
import 'package:flutter_template/app/app_routes.dart';
import 'package:get/route_manager.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Flutter architect templete",
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.getPages,
    );
  }
}
