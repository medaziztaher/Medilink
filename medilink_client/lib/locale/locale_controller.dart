import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../utils/constatnts.dart';
import '../utils/prefs.dart';


class MyLocaleController extends GetxController {
  final pref = Pref();
  Locale? initialLang;

  @override
  void onInit() {
    super.onInit();
    initialLang = pref.prefs?.getString(kLangSave) == null
        ? Get.deviceLocale
        : Locale(pref.prefs!.getString(kLangSave)!);
  }

  void changeLang(String langCode) {
    Locale locale;
    switch (langCode) {
      case 'en':
        locale = const Locale('en', 'US'); 
        break;
      case 'fr':
        locale = const Locale('fr', 'FR'); 
        break;
      case 'ar':
        locale = const Locale('ar', 'TN');
        break;
      default:
        locale = Get.deviceLocale!;
    }
    pref.prefs!.setString(kLangSave, langCode);
    Get.updateLocale(locale);
  }
}
