import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:dbug_webapp/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/color_utils.dart';
import '../utils/app_layout.dart';
import '../utils/app_style.dart';
import '../widget/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  bool isWasConnectionLoss = false;
  bool mIsPermissionGrant = false;

  InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    supportZoom: false,
    userAgent:
        'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.163 Mobile Safari/537.36',
    mediaPlaybackRequiresUserGesture: false,
    allowFileAccessFromFileURLs: true,
    useOnDownloadStart: true,
    javaScriptCanOpenWindowsAutomatically: true,
    allowFileAccess: true,
    allowsInlineMediaPlayback: true,
    useHybridComposition: true,
    allowContentAccess: true,
  );

  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          mIsPermissionGrant = true;
          setState(() {});
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Future<bool> exitApp() async {
      if (await homeController.webViewController!.canGoBack()) {
        homeController.webViewController!.goBack();
        return false;
      } else {
        exit(0);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        exitApp();
      },
      child: Scaffold(
        drawerEdgeDragWidth: 0,
        appBar: CustomAppBar(
          title: '',
          isBackButtonExist: false,
          preferredHeight: 0,
        ),
        backgroundColor: ColorUtils.getBackGround(),
        body: Obx(() {
          return homeController.isLoaded.value
              ? InAppWebView(
                  key: Key(homeController.mainUrl.value),
                  initialUrlRequest:
                      URLRequest(url: WebUri(homeController.mainUrl.value)),
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialSettings: settings,
                  pullToRefreshController:
                      homeController.pullToRefreshController,
                  onWebViewCreated: (controller) {
                    homeController.webViewController = controller;
                  },
                  onLoadStart: (controller, url) {},
                  onEnterFullscreen: (controller) {
                    controller.evaluateJavascript(
                        source: 'Android.enterFullscreen()');
                    AppLayout.screenLandscape(topStatus: true);
                  },
                  onExitFullscreen: (controller) {
                    controller.evaluateJavascript(
                        source: 'Android.exitFullscreen()');
                    AppLayout.screenPortrait1();
                  },
                  onLoadStop: (controller, url) async {
                    homeController.pullToRefreshController?.endRefreshing();
                    if (!homeController.isHeader.value) {
                      homeController.webViewController!
                          .evaluateJavascript(
                              source:
                                  "javascript:(function() { var head = document.getElementsByTagName('header')[0];head.parentNode.removeChild(head);})()")
                          .then((value) =>
                              debugPrint('Page finished loading Javascript'))
                          .catchError((onError) {});
                    }
                    if (!homeController.isFooter.value) {
                      homeController.webViewController!
                          .evaluateJavascript(
                              source:
                                  "javascript:(function() { var footer = document.getElementsByTagName('footer')[0];footer.parentNode.removeChild(footer);})()")
                          .then((value) =>
                              debugPrint('Page finished loading Javascript'))
                          .catchError((onError) {});
                    }
                  },
                  onReceivedError: (controller, request, error) {
                    homeController.pullToRefreshController?.endRefreshing();
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    Uri uri = navigationAction.request.url!;
                    String url = uri.toString();
                    if (Platform.isAndroid && url.contains("intent")) {
                      if (url.contains("maps")) {
                        var newURL = url.replaceAll("intent://", "https://");
                        if (await canLaunchUrl(Uri.parse(newURL))) {
                          await launchUrl(Uri.parse(newURL));
                          return NavigationActionPolicy.CANCEL;
                        }
                      } else {
                        var newURL = url.replaceAll("intent://", "https://");
                        launchUrl(Uri.parse(newURL),
                            mode: LaunchMode.externalApplication);
                        return NavigationActionPolicy.CANCEL;
                      }
                    } else if (![
                      "http",
                      "https",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);

                        return NavigationActionPolicy.CANCEL;
                      }
                    } else if (url.contains(RegExp(
                        r"(linkedin\.com|market:\/\/|whatsapp:\/\/|truecaller:\/\/|pinterest\.com|snapchat\.com|youtube\.com|spotify\.com|instagram\.com|play\.google\.com|mailto:|tel:|share=telegram|messenger\.com)"))) {
                      Uri parsedUrl = Uri.parse(url);
                      switch (parsedUrl.host) {
                        case "api.whatsapp.com":
                          if (parsedUrl.queryParameters.containsKey("phone") &&
                              parsedUrl.queryParameters["phone"] == "+") {
                            url = url.replaceFirst("=+", "=");
                          }
                          break;
                        case "whatsapp://send":
                          if (parsedUrl.queryParameters.containsKey("phone") &&
                              parsedUrl.queryParameters["phone"] == "%20") {
                            url = url.replaceFirst("/?phone=%20", "/?phone=");
                          }
                          break;
                        default:
                          if (!url.contains("whatsapp://")) {
                            url = Uri.encodeFull(url);
                          }
                      }

                      try {
                        if (await canLaunchUrl(Uri.parse(url))) {
                          launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        } else {
                          launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      } catch (e) {
                        launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }

                      return NavigationActionPolicy.CANCEL;
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onDownloadStartRequest: (controller, url) async {
                    await ChromeSafariBrowser().open(
                      url: WebUri(url.url.toString()),
                      settings: ChromeSafariBrowserSettings(
                        shareState: CustomTabsShareState.SHARE_STATE_ON,
                        barCollapsingEnabled: true,
                      ),
                    );
                  },
                  onGeolocationPermissionsShowPrompt:
                      (controller, origin) async {
                    var status = await Permission.location.request();

                    bool allow = status.isGranted;

                    return GeolocationPermissionShowPromptResponse(
                      origin: origin,
                      allow: allow,
                      retain: true,
                    );
                  },
                  onReceivedServerTrustAuthRequest:
                      (controller, challenge) async {
                    return ServerTrustAuthResponse(
                        action: ServerTrustAuthResponseAction.PROCEED);
                  },
                  onPermissionRequest: (controller, request) async {
                    List<PermissionResourceType> grantedResources = [];

                    for (var resource in request.resources) {
                      if (resource == PermissionResourceType.MICROPHONE) {
                        var status = await Permission.microphone.request();
                        if (status.isGranted) {
                          grantedResources.add(resource);
                        }
                      }
                      if (resource == PermissionResourceType.CAMERA) {
                        var status = await Permission.camera.request();
                        if (status.isGranted) {
                          grantedResources.add(resource);
                        }
                      }
                    }

                    return PermissionResponse(
                      resources: grantedResources,
                      action: grantedResources.isNotEmpty
                          ? PermissionResponseAction.GRANT
                          : PermissionResponseAction.DENY,
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: Styles.activeColorInDark,
                ));
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
