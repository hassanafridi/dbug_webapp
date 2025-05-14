import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ads/interstitial_ad.dart';
import '../model/ads_model.dart';
import '../model/settings_model.dart';
import '../routes/route.dart';
import '../utils/color_utils.dart';
import '../utils/constant.dart';
import '../utils/app_layout.dart';
import '../ads/app_open_ad_manager.dart';
import '../utils/app_pref.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  Future<void> _getFcmToken(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      _saveFCMTOKEN(context, fcmToken!, "");
    }
  }

  Future<void> _saveFCMTOKEN(
      BuildContext context, String token, String phoneModel) async {
    AppPref.sharedPref("FCM_TOKEN", false);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneModel = androidInfo.model;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneModel = iosInfo.model;
    }
    var url = Uri.parse(Constant.fcmTokenUrl);
    final response = await http.post(url, body: {
      'device_token': token,
      'device_name': phoneModel,
    });
    if (response.statusCode == 200) {
      print("FCM TOKEN onResponse: ${response.statusCode}");
    } else {
      print('Error sending FCM token: ${response.reasonPhrase}');
    }
  }

  Future<void> _getSharedData(BuildContext context) async {
    bool hasFCMToken = await AppPref.loadSharedPref("FCM_TOKEN", true);
    if (hasFCMToken) {
      _getFcmToken(context);
    }
  }

  Future<void> getAdsData() async {
    final response = await http.get(
      Uri.parse('${Constant.baseUrl}${Constant.advertisementUrl}'),
      headers: {"Accept": "application/json"},
    );
    var data = jsonDecode(response.body.toString());
    AdsModel? adsModel;

    if (response.statusCode == 200) {
      adsModel = AdsModel.fromJson(data);
      AppPref.sharedPrefString(Constant.ADMOB_APP_ID, Constant.admobAppId);
      AppPref.sharedPrefString(Constant.ADSKEY, adsModel.data!.adTypes ?? '');
      AppPref.sharedPrefString(
          Constant.BANNER_ADS, adsModel.data!.admobBanner ?? '');
      AppPref.sharedPrefString(
          Constant.INTER_ADS, adsModel.data!.admobInter ?? '');
      AppPref.sharedPrefString(
          Constant.NATIVE_ADS, adsModel.data!.admobNative ?? '');
      AppPref.sharedPrefString(
          Constant.REWARD_ADS, adsModel.data!.admobReward ?? '');
      AppPref.sharedPrefString(Constant.OpenAds, adsModel.data!.openAds ?? '');
      AppPref.sharedPrefString(
          Constant.UNITY_APP_APP_ID, adsModel.data!.unityAppIdGameId ?? '');
      AppPref.sharedPrefString(
          Constant.STARTAPP_APP_ID, adsModel.data!.startappAppId ?? '');
      AppPref.sharedPrefString(
          Constant.APPNEX_INTER, adsModel.data!.appnextPlacementId ?? '');
      AppPref.sharedPrefString(
          Constant.IRON_APP_ID, adsModel.data!.ironAppKey ?? '');

      AppPref.sharedPrefString(
          Constant.GNATIVE_ID, adsModel.data!.admobNative ?? '');
      AppPref.sharedPrefString(
          Constant.GINTERS_ID, adsModel.data!.admobInter ?? '');
      AppPref.sharedPrefString(
          Constant.GBANNER_ID, adsModel.data!.admobBanner ?? '');
      AppPref.sharedPrefString(
          Constant.FBBANNER_ID, adsModel.data!.fbBanner ?? '');
      AppPref.sharedPrefString(
          Constant.FBINTERS_ID, adsModel.data!.fbInter ?? '');
      AppPref.sharedPrefString(
          Constant.FBNATIVE_ADS, adsModel.data!.fbNative ?? '');
      AppPref.sharedPrefString(
          Constant.FBREWARD_ADS, adsModel.data!.fbReward ?? '');
      AppPref.sharedPrefInt(
          Constant.adsInterval, adsModel.data!.industrialInterval ?? 3);

      AdmobHelper admobHelper = AdmobHelper();
      admobHelper.initialization();

      appOpenAdManager.loadAd();
    }
  }

  Future<void> getSettingsData() async {
    final response = await http.get(
      Uri.parse('${Constant.baseUrl}${Constant.settingsUrl}'),
      headers: {"Accept": "application/json"},
    );
    var data = jsonDecode(response.body.toString());

    SettingsModel? settingsModel;

    if (response.statusCode == 200) {
      settingsModel = SettingsModel.fromJson(data);
      AppPref.sharedPrefString(
          Constant.privacyUrl, settingsModel.data![0].privacyPolicyUrl ?? '');
      AppPref.sharedPrefString(Constant.termsConditionUrl,
          settingsModel.data![0].termsAndConditionUrl ?? '');
      AppPref.sharedPrefString(
          Constant.aboutUsUrl, settingsModel.data![0].aboutUsUrl ?? '');
      AppPref.sharedPrefString(
          Constant.rateUsUrl, settingsModel.data![0].rateUsUrl ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLayout.screenPortrait1();
    _getSharedData(context);
    getAdsData();
    getSettingsData();
    Future.delayed(const Duration(seconds: 2), () {
      if (AppOpenAdManager.isLoaded) {
        appOpenAdManager.showAdIfAvailable();
        Get.offAllNamed(Routes.bottomBar);
      } else {
        Get.offAllNamed(Routes.bottomBar);
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return Image.asset(
              ColorUtils.getMode()
                  ? 'assets/images/dark_splash.png'
                  : 'assets/images/splash.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
            );
          }),
        ],
      ),
    );
  }
}
