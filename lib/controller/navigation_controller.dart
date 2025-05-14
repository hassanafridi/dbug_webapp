import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var index = 1.obs;

  final PageController pageController = PageController(initialPage: 1);

  void setIndex(int i) {
    if ((i - index.value).abs() > 1) {
      index.value = i;
      pageController.jumpToPage(i);
    } else {
      index.value = i;
      pageController.animateToPage(
        index.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
