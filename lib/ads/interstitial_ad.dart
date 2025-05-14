import 'package:flutter/cupertino.dart';
import 'package:get/instance_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../utils/color_utils.dart';
import '../utils/constant.dart';
import '../utils/app_pref.dart';
import '../controller/ads_callback_controller.dart';

InterstitialAd? _interstitialAd;
String interCode = "";
String bannerCode = "";
String adsType = '';

class AdmobHelper {
  static bool isBannerLoaded = false;

  initialization() async {
    adsType = await AppPref.loadSharedPrefString(Constant.ADSKEY);

    if (adsType.contains("0")) {
      interCode = await AppPref.loadSharedPrefString(Constant.INTER_ADS);
      bannerCode = await AppPref.loadSharedPrefString(Constant.BANNER_ADS);
      createInterad();
    } else if (adsType.contains("6")) {
      loadUnityIntAd();
    }
  }

  // create interstitial ads
  void createInterad() {
    InterstitialAd.load(
      adUnitId: interCode,
      request: const AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
      }, onAdFailedToLoad: (LoadAdError error) {
        _interstitialAd = null;
      }),
    );
  }

  void showInterad(BuildContext context) {
    if (adsType.contains("0")) {
      if (_interstitialAd == null) {
        createInterad();
        return;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {},
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            ad.dispose();
            createInterad();
            Get.find<AdsCallBackController>().setDismiss();
          },
          onAdFailedToShowFullScreenContent:
              (InterstitialAd ad, AdError aderror) {
            ad.dispose();
            createInterad();
            Get.find<AdsCallBackController>().setFailed();
          });
      _interstitialAd!.show();
    } else if (adsType.contains("6")) {
      showIntAd();
    }
  }

  static Future<void> loadUnityIntAd() async {
    await UnityAds.load(
      placementId: 'Interstitial_Android',
      onComplete: (placementId) => print('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  static Future<void> showIntAd() async {
    UnityAds.showVideoAd(
        placementId: 'Interstitial_Android',
        onStart: (placementId) => print('Video Ad $placementId started'),
        onClick: (placementId) => print('Video Ad $placementId click'),
        onSkipped: (placementId) => print('Video Ad $placementId skipped'),
        onComplete: (placementId) async {
          await loadUnityIntAd();
        },
        onFailed: (placementId, error, message) async {
          await loadUnityIntAd();
        });
  }

  static Widget showUnityBannerAd() {
    return UnityBannerAd(
        placementId: "Banner_Android",
        onClick: (placementId) => debugPrint('Video Ad $placementId click'),
        onFailed: (placementId, error, message) async {
          await loadUnityBannerAd();
        },
        onLoad: (value) async {
          await loadUnityBannerAd();
          isBannerLoaded = true;
          debugPrint(value);
        });
  }

  static Future<void> loadUnityBannerAd() async {
    await UnityAds.load(
      placementId: 'Banner_Android',
      onComplete: (placementId) => debugPrint('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Load Failed $placementId: $error $message'),
    );
  }

  static BannerAd getBannerAd() {
    BannerAd bAd = BannerAd(
        size: AdSize.smartBanner,
        adUnitId: bannerCode,
        listener: BannerAdListener(
            onAdClosed: (Ad ad) {},
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdLoaded: (Ad ad) {
              isBannerLoaded = true;
            },
            onAdOpened: (Ad ad) {}),
        request: const AdRequest());
    bAd.load();
    return bAd;
  }

  static AdWidget buildAdWidget() {
    return AdWidget(ad: getBannerAd());
  }

  static Widget showBanner(BuildContext context) {
    if (adsType.contains("0")) {
      return Container(
        height: isBannerLoaded ? 50 : 0,
        color: ColorUtils.getBackGround(),
        child: buildAdWidget(),
      );
    } else if (adsType.contains("6")) {
      return Container(
        height: isBannerLoaded ? 50 : 0,
        color: ColorUtils.getBackGround(),
        child: showUnityBannerAd(),
      );
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }
}
