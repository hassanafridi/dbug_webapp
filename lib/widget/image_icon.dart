import 'package:dbug_webapp/utils/color_utils.dart';
import 'package:dbug_webapp/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_style.dart';

class CustomImageIcon extends StatelessWidget {
  final String imagePath;
  final String imagePathActive;
  final String name;
  final double size;
  final bool active;

  const CustomImageIcon({
    super.key,
    required this.imagePath,
    required this.size,
    required this.name,
    required this.active, required this.imagePathActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            active ? imagePathActive : imagePath,
            color: active ? ColorUtils.getActiveBottom() : const Color(0xFF575757),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: !active
              ? prLight.copyWith(
                  fontSize: 16,
                  color: Styles.textColorDarkLight,
                )
              : prMedium.copyWith(
                  fontSize: 16,
                  color: ColorUtils.getActiveBottom(),
                ),
        )
      ],
    );
  }
}
