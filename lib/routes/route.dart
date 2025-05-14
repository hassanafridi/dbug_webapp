import 'package:dbug_webapp/screen/no_internet.dart';
import 'package:dbug_webapp/screen/splash_screen.dart';
import 'package:dbug_webapp/widget/bottom_bar.dart';
import 'package:get/get.dart';

import '../screen/web_screen.dart';

abstract class Routes {
  static const splash = '/';
  static const bottomBar = '/bottomBar';
  static const noInternet = '/noInternet';
  static const webView = '/webView';
}

abstract class AppPage {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.bottomBar,
      page: () => BottomBar(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.noInternet,
      page: () => NoInternet(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.webView,
      page: () => WebScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
