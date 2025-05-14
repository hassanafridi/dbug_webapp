import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../ads/interstitial_ad.dart';
import '../dialog/language_dialog.dart';
import '../controller/theme_controller.dart';
import '../routes/route.dart';
import '../utils/app_layout.dart';
import '../utils/color_utils.dart';
import '../utils/constant.dart';
import '../utils/app_pref.dart';
import '../widget/Settings/card_widget.dart';
import '../widget/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String aboutUs = '';
  String privacyPolicy = '';
  String termsCondition = '';
  String rateUs = '';
  late ThemeController themeController;

  @override
  void initState() {
    super.initState();
    themeController = Get.find<ThemeController>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: ColorUtils.getBackGround(),
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.settings,
          isBackButtonExist: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: AppLayout.getHeight(context, 15),
            ),
            CustomCardWidget(
              onTap: (value) {
                themeController.changeTheme(value, "darkMode");
              },
              imagePath: 'assets/images/ic_mode.svg',
              title: AppLocalizations.of(context)!.dark_mode,
              isToggle: themeController.currentTheme.value,
            ),
            CustomCardWidget(
                onTap: () async {
                  await Get.dialog(
                    LanguageDialog(),
                    barrierDismissible: false,
                    useSafeArea: false,
                  );
                },
                imagePath: 'assets/images/ic_language.svg',
                title: AppLocalizations.of(context)!.language_name),
            CustomCardWidget(
                onTap: () {
                  Get.toNamed(Routes.webView, arguments: {
                    "url": aboutUs,
                    "title": AppLocalizations.of(context)!.about
                  });
                },
                imagePath: 'assets/images/ic_info.svg',
                title: AppLocalizations.of(context)!.about),
            CustomCardWidget(
                onTap: () {
                  Get.toNamed(Routes.webView, arguments: {
                    "url": privacyPolicy,
                    "title": AppLocalizations.of(context)!.privacy_policy
                  });
                },
                imagePath: 'assets/images/ic_lock.svg',
                title: AppLocalizations.of(context)!.privacy_policy),
            CustomCardWidget(
                onTap: () {
                  Get.toNamed(Routes.webView, arguments: {
                    "url": termsCondition,
                    "title": AppLocalizations.of(context)!.term_con
                  });
                },
                imagePath: 'assets/images/ic_terms.svg',
                title: AppLocalizations.of(context)!.term_con),
            CustomCardWidget(
                onTap: () {
                  if (rateUs.isNotEmpty) {
                    Share.share(rateUs, subject: 'Share ${Constant.appName}');
                  }
                },
                imagePath: 'assets/images/ic_share.svg',
                title: AppLocalizations.of(context)!.share),
            CustomCardWidget(
                onTap: () {
                  Get.toNamed(Routes.webView, arguments: {
                    "url": rateUs,
                    "title": AppLocalizations.of(context)!.rate
                  });
                },
                imagePath: 'assets/images/ic_star.svg',
                title: AppLocalizations.of(context)!.rate),
          ],
        ),
        bottomNavigationBar: AdmobHelper.showBanner(context),
      );
    });
  }

  void getData() async {
    aboutUs = await AppPref.loadSharedPrefString(Constant.aboutUsUrl);
    privacyPolicy = await AppPref.loadSharedPrefString(Constant.privacyUrl);
    termsCondition =
        await AppPref.loadSharedPrefString(Constant.termsConditionUrl);
    rateUs = await AppPref.loadSharedPrefString(Constant.rateUsUrl);
    setState(() {});
  }
}
