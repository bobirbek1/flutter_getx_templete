

   
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void showSnackbar(String message,
    {Function? onDissmissed, bool isError = true}) {
  Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        isError ? "Xatolik yuz berdi!" : "Muvaffaqiyatli bajarildi!",
        style: TextStyle(color: isError ? Colors.red : Colors.green),
      ),
      messageText: Text(message),
      dismissDirection: DismissDirection.up,
      isDismissible: true,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      borderRadius: 8,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      duration: const Duration(milliseconds: 1000),
      icon: Icon(
        isError ? Icons.error : Icons.check_circle_rounded,
        color: isError ? Colors.red : Colors.green,
      ),
      snackbarStatus: (status) {
        Get.log("snackbar status is $status");
        if (status == SnackbarStatus.CLOSED) {
          if (onDissmissed != null) onDissmissed();
        }
      },
    ),
  );
}

void showBottomSheetDialog(Widget child,
    {bool isdismissible = true, bool enableDrug = true}) {
  Get.bottomSheet(
      SingleChildScrollView(
        child: child,
      ),
      isDismissible: isdismissible,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      isScrollControlled: true,
      enableDrag: enableDrug,);
}

Dio addInterceptor(Dio dio) {
  return dio
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
}

extension ParseDate on String {
  DateTime? parseDate() {
    final date = split("+");
    return date.isNotEmpty
        ? DateFormat("yyyy-MM-dd'T'hh:mm:ss").parse(date.first)
        : null;
  }
}