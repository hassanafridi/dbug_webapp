import 'package:dbug_webapp/utils/app_layout.dart';
import 'package:dbug_webapp/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/color_utils.dart';

class NoInternet extends StatefulWidget {
  // final Function onTap;
  const NoInternet({super.key});

  @override
  NoInternetState createState() => NoInternetState();
}

class NoInternetState extends State<NoInternet> {

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    AppLayout.screenPortrait1();
    return Scaffold(
      backgroundColor: ColorUtils.getBackGround(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/no_internet.svg',),
            SizedBox(height: AppLayout.getHeight(context, 50),),
            Text(AppLocalizations.of(context)!.ooops, style: prMedium.copyWith(fontSize: 48,color: ColorUtils.getPrimaryText())),
            SizedBox(height: AppLayout.getHeight(context, 30),),
            Text(AppLocalizations.of(context)!.no_internet_msg,textAlign: TextAlign.center, style: nuMedium.copyWith(fontSize: 20,color: ColorUtils.getSecondText())),
            // GestureDetector(
            //   onTap: (){
            //     widget.onTap();
            //   },
            //   child: Container(
            //     width: AppLayout.getScreenWidth(context),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(8),
            //         color: ColorUtils.getBlackWhite(context)
            //     ),
            //     padding: const EdgeInsets.symmetric(vertical: 12),
            //     margin: EdgeInsets.only(left: 20,right: 20,top: AppLayout.getHeight(context, 50)),
            //     child: Text('Try again',textAlign: TextAlign.center,style: prSemiBold.copyWith(fontSize: 18,color: ColorUtils.getBlackWhiteReverse(context)),),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
