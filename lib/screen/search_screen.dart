
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import '../ads/interstitial_ad.dart';
import '../controller/ads_callback_controller.dart';
import '../controller/home_controller.dart';
import '../controller/navigation_controller.dart';
import '../utils/color_utils.dart';
import '../utils/constant.dart';
import '../utils/app_layout.dart';
import '../utils/app_style.dart';
import '../utils/styles.dart';
import '../widget/Settings/card_widget.dart';
import '../widget/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isUrlFieldActive = false;
  late HomeController homeController;
  late NavigationController navController;
  late AdsCallBackController adsCheck;

  @override
  void initState() {
    super.initState();
    navController = Get.find<NavigationController>();
    homeController = Get.find<HomeController>();
    adsCheck = Get.find<AdsCallBackController>();
    _urlController.text = 'sdfasdfasdfsd://';
    _focusNode.addListener(() {
      setState(() {
        isUrlFieldActive = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.getBackGround(),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.try_search,
        isBackButtonExist: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppLayout.getScreenWidth(context),
              margin: EdgeInsets.symmetric(
                  vertical: AppLayout.getHeight(context, 15),
                  horizontal: AppLayout.getWidth(context, 15)),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: ColorUtils.getCardBg(),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/ic_world.svg',
                    color: ColorUtils.getWhiteMix(),
                  ),
                  SizedBox(
                    width: AppLayout.getWidth(context, 15),
                  ),
                  Expanded(
                      child: TextField(
                          maxLines: 1,
                          controller: _urlController,
                          style: nuSemiBold.copyWith(
                              fontSize: 20,
                              color: isUrlFieldActive
                                  ? ColorUtils.getWhiteMix()
                                  : Styles.textColorDarkLight),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          focusNode: _focusNode,
                          cursorColor: Styles.activeColorInDark,
                          onSubmitted: (text) {
                            homeController.loadCount().then((value) {
                              if (homeController.countAds.value == 0) {
                                homeController.admobHelper.showInterad(context);
                                adsCheck.openAdsOnMessageEvent().then((value) {
                                  if (value.contains(Constant.DISMISS)) {
                                    homeController.saveAds().then((value) {
                                      homeController.onChangeUrl(text);
                                      navController.setIndex(1);
                                    });
                                  } else {
                                    homeController.onChangeUrl(text);
                                    navController.setIndex(1);
                                  }
                                });
                              } else {
                                homeController.saveAds().then((value) {
                                  homeController.onChangeUrl(text);
                                  navController.setIndex(1);
                                });
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'http://',
                            border: InputBorder.none,
                            hintStyle: nuSemiBold.copyWith(
                              fontSize: 20,
                              color: Styles.textColorDarkLight,
                            ),
                          ))),
                  GestureDetector(
                    onTap: () {

                      homeController.loadCount().then((value) {
                        if (homeController.countAds.value == 0) {
                          homeController.admobHelper.showInterad(context);
                          adsCheck.openAdsOnMessageEvent().then((value) {
                            if (value.contains(Constant.DISMISS)) {
                              homeController.saveAds().then((value) {
                                homeController.onChangeUrl(_urlController.text);
                                navController.setIndex(1);
                              });
                            } else {
                              homeController.onChangeUrl(_urlController.text);
                              navController.setIndex(1);
                            }
                          });
                        } else {
                          homeController.saveAds().then((value) {
                            homeController.onChangeUrl(_urlController.text);
                            navController.setIndex(1);
                          });
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Styles.activeColorInDark,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/ic_right_arrow.svg",
                        color: Styles.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: AppLayout.getHeight(context, 25),
                  left: AppLayout.getWidth(context, 15),
                  bottom: AppLayout.getHeight(context, 15)),
              child: Text(
                AppLocalizations.of(context)!.try_demo,
                style: prMedium.copyWith(
                    fontSize: 24, color: ColorUtils.getPrimaryText()),
              ),
            ),
            Obx(() {
              return ListView.builder(
                itemCount: homeController.webItem.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = homeController.webItem[index];
                  return CustomCardWidget(
                    onTap: () {
                      homeController.onChangeUrl(
                        item.url,
                        isHeader: item.showHeader == 0,
                        isFooter: item.showFooter == 0,
                      );
                      navController.setIndex(1);
                    },
                    title: item.name,
                  );
                },
              );
            })
          ],
        ),
      ),
      bottomNavigationBar: AdmobHelper.showBanner(context),
    );
  }
}
