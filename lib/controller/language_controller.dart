import 'dart:ui';

import 'package:get/get.dart';
import '/utils/app_pref.dart';

class LanguageController extends GetxController {
  var language = Locale('en').obs;

  Future<void> changeLanguage(String langCode) async {
    var locale = Locale(langCode);
    Get.updateLocale(locale);
    await AppPref.sharedPrefString("language", langCode);
    language.value = locale;
  }

  Future<void> initialize() async {
    String storedLanguage = await AppPref.loadSharedPrefString("language",defaultValue: 'en');
    language.value = Locale(storedLanguage);
    Get.updateLocale(language.value);
  }


  @override
  void onInit() {
    super.onInit();
    initialize();
  }
}
