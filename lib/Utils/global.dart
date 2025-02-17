import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class Global {

  static double sWidth = 0, sHeight = 0;

  static deviceSize(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
  }

  static topBarThemeSettings(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ));
  }

  static int getBackGroundTimeBased() {
    int hour = DateTime.now().hour;

    int selectedBgImageCount = 1;
    if (hour >= 6 && hour < 12) {
      selectedBgImageCount = 1;
    } else if (hour >= 12 && hour < 17) {
      selectedBgImageCount = 2;
    } else if (hour >= 17 && hour < 20) {
      selectedBgImageCount = 3;
    } else {
      selectedBgImageCount = 4;
    }
    return selectedBgImageCount;
  }
}
