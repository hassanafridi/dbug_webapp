import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'controller/ads_callback_controller.dart';
import 'controller/home_controller.dart';
import 'controller/language_controller.dart';
import 'controller/navigation_controller.dart';
import 'controller/theme_controller.dart';
import 'routes/route.dart';
import 'l10n/l10n.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'controller/network_controller.dart';  // Make sure this is imported

// Unity Ads initialization
Future<void> unityAdsInitialization() async {
  await UnityAds.init(
    gameId: 'your-unity-app-id',
    onComplete: () {},
    onFailed: (error, message) {},
  );
}

// Main entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Ads
  MobileAds.instance.initialize();

  // Unity Ads initialization (since Firebase is not needed)
  await unityAdsInitialization();

  // Initialize controllers with GetX
  Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
  Get.lazyPut<NavigationController>(() => NavigationController(), fenix: true);
  Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  Get.lazyPut<AdsCallBackController>(() => AdsCallBackController(), fenix: true);
  Get.put(NetworkController());  // NetworkController

  // Start the app
  runApp(MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Get.find<ThemeController>().currentTheme.value
          ? MyThemes.darkTheme
          : MyThemes.lightTheme,
      supportedLocales: L10.all,  // Supported locales for the app
      locale: Get.find<LanguageController>().language.value,  // Current language
      localizationsDelegates: [
        AppLocalizations.delegate,  // Generated localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: Routes.splash,  // Initial route when the app starts
      getPages: AppPage.routes,  // Define routes for navigation
    );
  }
}
