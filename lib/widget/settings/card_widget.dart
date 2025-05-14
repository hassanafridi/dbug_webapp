import 'package:dbug_webapp/utils/color_utils.dart';
import 'package:dbug_webapp/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_layout.dart';

class CustomCardWidget extends StatelessWidget {
  final Function onTap;
  final String? imagePath;
  final String title;
  final Color? cardColor;
  final Color? textColor;
  final bool? isToggle;

  const CustomCardWidget({
    super.key,
    required this.onTap,
    this.imagePath,
    required this.title,
    this.cardColor,
    this.textColor,
    this.isToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (isToggle == null) {
          onTap();
        }
      },
      child: Container(
        width: AppLayout.getScreenWidth(context),
        margin: EdgeInsets.symmetric(
            vertical: AppLayout.getHeight(context, 5),
            horizontal: AppLayout.getWidth(context, 15)),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor ?? ColorUtils.getCardBg(),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            if (imagePath != null)
              SvgPicture.asset(
                imagePath!,
                color: ColorUtils.getWhiteMix(),
              ),
            SizedBox(
              width: AppLayout.getWidth(context, imagePath != null ? 15 : 5),
            ),
            Text(
              title,
              style: nuSemiBold.copyWith(
                  color: textColor ?? ColorUtils.getWhiteMix(),
                  fontSize: 18),
            ),
            Expanded(child: Container()),
            isToggle != null
                ? Transform.scale(
                    scale: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorUtils.getActiveBottom(),
                          width: 1.0, // Set the border width here
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: CupertinoSwitch(
                        value: isToggle!,
                        activeTrackColor: Colors.transparent,
                        thumbColor: ColorUtils.getActiveBottom(),
                        onChanged: (bool? value) => onTap(value),
                        inactiveTrackColor: Colors.transparent,
                      ),
                    ),
                  )
                : SvgPicture.asset(
                    "assets/images/ic_right_arrow.svg",
                    color: ColorUtils.getWhiteMix(),
                  ),
          ],
        ),
      ),
    );
  }
}
