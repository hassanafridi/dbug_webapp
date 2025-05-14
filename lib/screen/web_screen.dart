import 'dart:io';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/interstitial_ad.dart';
import '../utils/app_style.dart';
import '../widget/custom_app_bar.dart';

class WebScreen extends StatefulWidget {
  final bool? isHeader, isFooter;

  const WebScreen({super.key, this.isHeader, this.isFooter});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  String url = "https://rdr.dropchamp.com";

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

  bool check(List<String> list, String item) {
    for (String i in list) {
      if (item.contains(i)) return true;
    }
    return false;
  }

  String title = 'Dropchamp';

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, String>;
    title = arguments['title'] ?? '';
    url = arguments['url'] ?? '';
    pullToRefreshController = PullToRefreshController(
      settings:
          PullToRefreshSettings(color: Styles.activeColorInDark, enabled: true),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: settings,
        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            this.url = url.toString();
          });
        },
        onLoadStop: (controller, url) async {
          pullToRefreshController?.endRefreshing();
          if (widget.isHeader != null && !widget.isHeader!) {
            webViewController!
                .evaluateJavascript(
                    source:
                        "javascript:(function() { var head = document.getElementsByTagName('header')[0];head.parentNode.removeChild(head);})()")
                .then((value) => debugPrint('Page finished loading Javascript'))
                .catchError((onError) {});
          }
          if (widget.isFooter != null && !widget.isFooter!) {
            webViewController!
                .evaluateJavascript(
                    source:
                        "javascript:(function() { var footer = document.getElementsByTagName('footer')[0];footer.parentNode.removeChild(footer);})()")
                .then((value) => debugPrint('Page finished loading Javascript'))
                .catchError((onError) {});
          }
        },
        onReceivedError: (controller, request, error) {
          pullToRefreshController!.endRefreshing();
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          setState(() {
            this.url = url.toString();
          });
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          Uri uri = navigationAction.request.url!;
          var url = navigationAction.request.url.toString();

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
          } else if (!["http", "https", "chrome", "data", "javascript", "about"]
              .contains(uri.scheme)) {
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
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
            } catch (e) {
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
      ),
      bottomNavigationBar: AdmobHelper.showBanner(context),
    );
  }
}
