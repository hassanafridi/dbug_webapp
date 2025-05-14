import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_utils.dart';

class AppLayout {
  static getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context, double pixels) {
    double height = getScreenHeight(context);
    return (pixels / 932) * height;
  }

  static double getWidth(BuildContext context, double pixels) {
    double width = getScreenWidth(context);
    return (pixels / 430) * width;
  }

  static screenPortrait() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static screenPortrait1() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    systemStatusColor(colors: Colors.transparent);
  }

  static screenLandscape({bool? topStatus}) {
    if (topStatus ?? true) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static screenStatus(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  static systemStatusColor({Color? colors}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colors ?? ColorUtils.getBackGround(),
      systemNavigationBarColor:
          colors ?? ColorUtils.getBackGround(), // Set color here
    ));
  }

  static bool isColorLight(Color colors) {
    double luminance = colors.computeLuminance();
    return luminance > 0.5;
  }
}
