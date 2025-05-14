import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import '/utils/app_style.dart';
import '/controller/theme_controller.dart';

class ColorUtils {
  static final ThemeController _themeController = Get.find<ThemeController>();

  static bool getMode() {
    return _themeController.currentTheme.value;
  }

  static Color getBackGround() {
    return getMode() ? Styles.primaryColorDark : Styles.primaryColor;
  }

  static Color getPrimaryText() {
    return getMode() ? Styles.primaryColor : Styles.textColorDark;
  }

  static Color getSecondText() {
    return getMode() ? Styles.textColorDarkLight : Styles.lineColorDark;
  }

  static Color getWhiteMix() {
    return getMode() ? Styles.textColorLight : Styles.textColorDark;
  }

  static Color getActiveBottom() {
    return getMode() ? Styles.activeColorInDark : Styles.textColorDark;
  }

  static Color getCardBg() {
    return getMode() ? Styles.cardDark : Styles.cardLight;
  }

  static Color getLineColor() {
    return getMode() ? Styles.lineColorDark : Styles.lineColor;
  }

  static Color getBottomLineColor() {
    return getMode() ? Styles.bottomLineColorDark : Styles.bottomLineColor;
  }

  static Color getBlackWhite() {
    return getMode() ? Styles.primaryColor : Styles.primaryColorDark;
  }

  static Color getBlackWhiteReverse() {
    return getMode() ? Colors.black : Colors.white;
  }

  static Color getShimmerBase() {
    return getMode() ? Styles.shimmerBaseDark : Styles.shimmerBaseLight;
  }

  static Color getShimmerHigh() {
    return getMode() ? Styles.shimmerHighDark : Styles.shimmerHighLight;
  }
}
