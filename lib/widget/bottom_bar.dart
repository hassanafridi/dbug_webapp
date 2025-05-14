import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import '../controller/navigation_controller.dart';
import '../screen/home_screen.dart';
import '../screen/settings_screen.dart';
import '/utils/color_utils.dart';
import '/utils/app_layout.dart';
import '../ads/app_open_ad_manager.dart';
import 'image_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with WidgetsBindingObserver {
  late NavigationController navController;

  @override
  Widget build(BuildContext context) {
    AppLayout.systemStatusColor();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (result, t) async {},
      child: Scaffold(
        backgroundColor: ColorUtils.getBackGround(),
        body: Stack(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(bottom: AppLayout.getHeight(context, 80)),
              child: PageView(
                controller: navController.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const HomeScreen(),
                  const SettingsScreen(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() {
                return Container(
                  height: AppLayout.getHeight(context, 80),
                  decoration: BoxDecoration(
                    color: ColorUtils.getCardBg(),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(33.0),
                      topRight: Radius.circular(33.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 0.0,
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 1),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            navController.setIndex(0);
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              color: Colors.transparent,
                              child: CustomImageIcon(
                                imagePath: 'assets/images/ic_search.svg',
                                imagePathActive:
                                    'assets/images/ic_search_active.svg',
                                name: AppLocalizations.of(context)!.search,
                                size: 28.0,
                                active: (navController.index.value == 0),
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            navController.setIndex(1);
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              color: Colors.transparent,
                              child: CustomImageIcon(
                                imagePath: 'assets/images/ic_home.svg',
                                imagePathActive:
                                    'assets/images/ic_home_active.svg',
                                name: AppLocalizations.of(context)!.home,
                                size: 28.0,
                                active: (navController.index.value == 1),
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            navController.setIndex(2);
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              color: Colors.transparent,
                              child: CustomImageIcon(
                                imagePath: 'assets/images/ic_setting.svg',
                                name: AppLocalizations.of(context)!.settings,
                                size: 28.0,
                                active: (navController.index.value == 2),
                                imagePathActive:
                                    'assets/images/ic_setting_active.svg',
                              )),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
        // bottomNavigationBar: ,
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return true;
  }

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    navController = Get.find<NavigationController>();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    navController.pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }
}
