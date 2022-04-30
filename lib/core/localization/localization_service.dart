



import 'package:flutter/material.dart';
import 'package:flutter_template/core/localization/en.dart';
import 'package:flutter_template/core/localization/ru.dart';
import 'package:flutter_template/core/localization/uz.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations{


  // Default locale
  static const locale =  Locale('ru', 'RU');

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('uz', 'UZ');



  @override
  Map<String, Map<String, String>> get keys => {
    'en_US' : en_EN,
    'uz_UZ' : uz_UZ,
    'ru_RU' : ru_RU,
  };

  static final langs = [
    "O'zbek",
    'Русский',
    "English"
  ];

   // Supported locales
  // Needs to be same order with langs
  static const locales = [
    Locale('uz', 'UZ'),
    Locale('ru', 'RU'),
    Locale('en','US'),
  ];

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale? _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }

}

