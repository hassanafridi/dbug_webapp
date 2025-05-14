import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import '../utils/app_layout.dart';
import '../utils/color_utils.dart';
import '../utils/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final Color? bgColor;
  final Color? leadingIconColor;
  final String? type;
  final TextStyle? textstyle;
  final double? preferredHeight;

  const CustomAppBar({super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.bgColor,
    this.type,
    this.textstyle,
    this.leadingIconColor,
    this.preferredHeight});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: bgColor ?? ColorUtils.getBackGround(),
          statusBarIconBrightness:
          AppLayout.isColorLight(bgColor ?? ColorUtils.getBackGround())
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarIconBrightness:
          AppLayout.isColorLight(bgColor ?? ColorUtils.getBackGround())
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor: bgColor ?? ColorUtils.getBackGround(),
        ),
        toolbarHeight: preferredHeight ?? 50,
        automaticallyImplyLeading: false,
        title: Text(title,
            style: textstyle ??
                prMedium.copyWith(
                    fontSize: 28, color: ColorUtils.getPrimaryText())),
        centerTitle: true,
        leading: isBackButtonExist
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: leadingIconColor ??
              Theme
                  .of(context)
                  .textTheme
                  .bodyLarge!
                  .color,
          onPressed: () =>
          onBackPressed != null ? onBackPressed!() : Get.back(),
        )
            : const SizedBox(),
        backgroundColor: bgColor ?? ColorUtils.getBackGround(),
        elevation: 0,
      );
    });
  }

  @override
  Size get preferredSize => Size(1170, preferredHeight ?? 50);
}
