import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controller/language_controller.dart';
import '../utils/color_utils.dart';
import '../utils/app_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/app_pref.dart';
import '../utils/styles.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late List<Item> itemList;
  String selectedLangCode = "";

  late LanguageController languageController;

  @override
  void initState() {
    super.initState();
    languageController = Get.find<LanguageController>();
    itemList = [
      Item("assets/images/flag_english.webp", "English", false, "en"),
      Item("assets/images/flag_bangla.webp", "বাংলা", false, "bn"),
      Item("assets/images/flag_spanish.webp", "Español", false, "es"),
      Item("assets/images/flag_turkey.webp", "Türkçe", false, "tr"),
    ];

    lang().then((value){
      for(int j=0;j<itemList.length;j++){
        if(itemList[j].code == value){
          handleItemTap(j);
          break;
        }
      }
    });
  }
  Future<String> lang()async{
    String language = await AppPref.loadSharedPrefString("language");
    if(language == "") {
      language = "en";
    }
    return language;
  }

  void handleItemTap(int index) {
    setState(() {
      selectedLangCode = itemList[index].code;
      for (int i = 0; i < itemList.length; i++) {
        itemList[i].select = (i == index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorUtils.getBackGround(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.choose_lang,
              style: nuBold.copyWith(fontSize: 20),
            ),
            SizedBox(height:AppLayout.getWidth(context,20)),
            Divider(
              height: 1,
              thickness: 1,
              color: ColorUtils.getLineColor(),
            ),
            ListView.builder(
              itemCount: itemList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    handleItemTap(index);
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 28,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(itemList[index].flag),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            margin: const EdgeInsets.all(10),
                          ),
                          SizedBox(width:AppLayout.getWidth(context,5)),
                          Text(
                            itemList[index].name,
                            style: nuMedium.copyWith(fontSize: 18),
                          ),
                          const Spacer(),
                          if (itemList[index].select)
                            SvgPicture.asset(
                              "assets/images/ic_select.svg",
                              width: AppLayout.getHeight(context,20),
                              height: AppLayout.getHeight(context,20),
                            ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: ColorUtils.getLineColor(),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height:AppLayout.getWidth(context,20)),
            ElevatedButton(
              onPressed: () {
                languageController.changeLanguage(selectedLangCode);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.getPrimaryText(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0.0,
                minimumSize: Size(AppLayout.getScreenWidth(context), 50),
              ),
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Satoshi',
                  color: ColorUtils.getBlackWhiteReverse(),
                ),
              ),
            ),
            SizedBox(height:AppLayout.getWidth(context,10)),
          ],
        ),
      ),
    );
  }
}

class Item {
  String flag;
  String name;
  String code;
  bool select;

  Item(this.flag, this.name, this.select, this.code);
}

String getLocalizedLanguageName(BuildContext context, String type) {
  return AppLocalizations.of(context)!.language_name;
}
