import 'package:flutter_template/app/app_routes.dart';
import 'package:flutter_template/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:get/route_manager.dart';

class AppPages {
  static final getPages = [
    GetPage(name: AppRoutes.HOME, page: () => const NumberTriviaPage()),
  ];
}
