import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/constant.dart';
import '../utils/app_pref.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;
  static bool isLoaded = false;
  static String adsType = '';

  void loadAd() async {
    adsType = await AppPref.loadSharedPrefString(Constant.ADSKEY);
    if (adsType.contains("0")) {
      AppOpenAd.load(
        adUnitId: await AppPref.loadSharedPrefString(Constant.OpenAds),
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            isLoaded = true;
          },
          onAdFailedToLoad: (error) {
            // Handle the error.
          },
        ),
      );
    }
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (_appOpenAd == null) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
