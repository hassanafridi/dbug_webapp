import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/utils/app_pref.dart';
import '../utils/app_style.dart';

class ThemeController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    initialize();
  }
  var currentTheme = false.obs;
  ThemeMode get themeMode => currentTheme.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> changeTheme(bool theme, String key) async {
    await AppPref.sharedPref(key, theme);
    currentTheme.value = theme;
  }

  Future<void> initialize() async {
    currentTheme.value = await AppPref.loadSharedPref("darkMode", false);
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
    primaryColor: Styles.textColorDark,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Styles.textColorDark,
      secondary: Styles.textColorDark,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: ThemeData.light().scaffoldBackgroundColor,
    primaryColor: Styles.primaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: Styles.primaryColor,
      secondary: Styles.primaryColor,
    ),
  );
}
