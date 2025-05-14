import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../ads/interstitial_ad.dart';
import '../model/navigation_model.dart';
import '../utils/constant.dart';
import '../utils/app_pref.dart';

class HomeController extends GetxController {
  // Reactive variables
  var isHeader = true.obs;
  var isFooter = true.obs;
  var isLoaded = false.obs;
  var webItem = <WebItem>[].obs;
  var mainUrl = ''.obs;
  var countAds = 0.obs;

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  AdmobHelper admobHelper = AdmobHelper();

  @override
  void onInit() {
    super.onInit();
    initState();
  }

  Future<void> loadCount() async {
    countAds.value = await AppPref.loadSharedPrefInt(Constant.adsInterval);
  }

  Future<void> saveAds() async {
    countAds.value = countAds.value == 0 ? 3 : countAds.value - 1;
    await AppPref.sharedPrefInt(Constant.adsInterval, countAds.value);
  }

  void initState() async {
    await getData();
    isLoaded.value = true;
  }

  Future<void> getData() async {
    try {
        webItem.value = [];
        mainUrl.value = "https://rdr.dropchamp.com/";
        isHeader.value = false;
        isFooter.value = false;

    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void onChangeUrl(String url, {bool? isHeader, bool? isFooter}) {
    mainUrl.value = url;
    if (isHeader != null) {
      this.isHeader.value = isHeader;
    }
    if (isFooter != null) {
      this.isFooter.value = isFooter;
    }
    loadUrl(url);
  }

  Future<void> loadUrl(String url) async {
    if (webViewController != null) {
      await webViewController!
          .loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    }

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.pink, enabled: true),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  Future<void> reload() async {
    if (Platform.isAndroid) {
      webViewController?.reload();
    } else if (Platform.isIOS) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(url: await webViewController?.getUrl()));
    }
  }

  Future<bool> canGoBack() async {
    return await webViewController?.canGoBack() ?? false;
  }

  void goBack() {
    webViewController?.goBack();
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import '../ads/interstitial_ad.dart';
// import '../model/navigation_model.dart';
// import '../utils/constant.dart';
// import 'package:http/http.dart' as http;
// import '../utils/app_pref.dart';
//
// class HomeNotifier with ChangeNotifier{
//   bool _isHeader = true;
//   bool _isFooter = true;
//   bool _isLoaded = false;
//   List<WebItem> _webItem = [];
//   InAppWebViewController? webViewController;
//   PullToRefreshController? pullToRefreshController;
//   String _mainUrl = '';
//   String get mainUrl => _mainUrl;
//   bool get isHeader => _isHeader;
//   bool get isFooter => _isFooter;
//   List<WebItem> get webItem => _webItem;
//   bool get isLoaded => _isLoaded;
//   AdmobHelper admobHelper = AdmobHelper();
//   int countAds = 0;
//
//   Future<void> loadCount() async {
//     countAds = await AppPref.loadSharedPrefInt(Constant.adsInterval);
//     notifyListeners();
//   }
//   Future<void> savedAds() async {
//     countAds == 0 ? countAds = 3 : countAds = countAds - 1;
//     AppPref.sharedPrefInt(Constant.adsInterval, countAds);
//     notifyListeners();
//   }
//   void initState() async {
//     await getData();
//     _isLoaded = true;
//     notifyListeners();
//   }
//
//   Future<void> getData() async {
//     try {
//       final response = await http.get(
//         Uri.parse('${Constant.baseUrl}${Constant.navigationUrl}'),
//         headers: {"Accept": "application/json"},
//       );
//       NavigationModel? navigationModel;
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         navigationModel = NavigationModel.fromJson(responseData);
//         _webItem = navigationModel.data.toList();
//         // if(navigationModel.data[0].url != "https://jwala.shop"){
//         //   _mainUrl = "https://jwala.shop";
//         // }else{
//           _mainUrl = navigationModel.data[0].url;
//         // }
//         _isHeader = navigationModel.data[0].showHeader==0;
//         _isFooter = navigationModel.data[0].showFooter==0;
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     }
//   }
//
//   void onChangeUrl(String url,{ bool? isHeader,bool? isFooter}) async{
//     _mainUrl = url;
//     if(isHeader != null){
//       _isHeader = isHeader;
//     }
//     if(isFooter != null){
//       _isFooter = isFooter;
//     }
//     notifyListeners();
//   }
//
//   Future<void> loadUrl(String url) async {
//     if (webViewController != null) {
//       await webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
//     }
//
//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(color: Colors.pink, enabled: true),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }
//
//   Future<void> reload() async {
//     if (Platform.isAndroid) {
//       webViewController?.reload();
//     } else if (Platform.isIOS) {
//       webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
//     }
//   }
//
//   Future<bool> canGoBack() async {
//     return await webViewController?.canGoBack() ?? false;
//   }
//
//   void goBack() {
//     webViewController?.goBack();
//   }
// }
