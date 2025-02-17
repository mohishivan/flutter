import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surya_tracker/Model/MindFulModel.dart';
import 'package:surya_tracker/Utils/colors.dart';
import '../Controller/home_screen_controller.dart';
import '../Utils/global.dart';
import '../Utils/helper.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  HomeScreenController homeController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {

    Global.deviceSize(context);

    return Scaffold(
      body: Obx(() {
        int sunIndex = (homeController.mindfulnessLevel.value * 8).round().clamp(0, 8);
        String sunImage = 'assets/images/sun${sunIndex + 1}.png';

      return Stack (
        alignment: Alignment.topCenter,
        children: [

          Container(
            margin: EdgeInsets.only(bottom: 170),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 800),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Container (
                key: ValueKey<int>(homeController.selectedBgImageCount.value),
                decoration: BoxDecoration(
                    image: DecorationImage (
                      image: AssetImage(getBackGroundImage(homeController.selectedBgImageCount.value)),
                      fit: BoxFit.cover,
                    )
                ),

                child: SafeArea(
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      topRightImgView(),
                      welcomeLabelView(),
                      sunImageView(sunImage, context),
                      percentagePopView(context),
                      //sliderView(),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Obx(() => isNightModeActive() ? Image.asset(Helper.snowImg) : SizedBox()),

          Align (
            alignment: Alignment.bottomCenter,
            child: bottomSheetView(),
          ),

          bgImageModeWisePopMenuView(),
        ],
      );
        },
        ),
    );
  }

  Widget bottomSheetView() {
    return Container (
      height: 210,
      padding: EdgeInsets.only(left: 40, right: 40, top: 13, bottom: 13),
      decoration: BoxDecoration (
        color: isNightModeActive() ? ColorName.bg4BottomSheet : ColorName.bottomSheetColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(35),
          topLeft: Radius.circular(35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text (
            "Last 30 Minutes",
            style: TextStyle (
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: Helper.interSemiBold,
                color: isNightModeActive() ? ColorName.whiteColor : ColorName.textColor1
            ),
          ),
          Padding (
              padding: EdgeInsets.only(top: 7, bottom: 0),
              child: Divider(color: isNightModeActive() ? ColorName.dividerColor2 : ColorName.dividerColor, height: 0.9)
          ),
          Flexible(
            child: AnimatedList(
              key: homeController.listKey,
              initialItemCount: homeController.mindFulData.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index, animation) {
                MindFulModel currentItem = homeController.mindFulData[index];
                return listItem(currentItem.mood, currentItem.time, currentItem.percentage, animation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem(String title, DateTime time, String percentage,Animation<double> animation) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

    return SlideTransition(
      position: slideAnimation,
      child: Padding (
        padding: const EdgeInsets.symmetric(vertical:3.0,horizontal: 0),
        child: Column(
          children: [
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipOval(child: Image.asset(title == "Disengaged" ? Helper.sun1 : title == "Normal" ? Helper.sun2 : Helper.sun3,height: 35,width: 35,)),
                SizedBox(width: 10),
                Expanded(
                    flex: 3,
                    child: Text(title, style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100,
                        fontFamily: Helper.interSemiBold,
                        color: isNightModeActive() ? ColorName.whiteColor : ColorName.darkGreyColor))
                ),

                Expanded(
                  flex: 2,
                  child: Text(homeController.convertTimeInFormat(time), style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100,
                      fontFamily: Helper.interSemiBold,
                      color: isNightModeActive() ? ColorName.whiteColor : ColorName.darkGreyColor))
                ),
                SizedBox(width: 5,),
                Expanded (
                  flex: 2,
                  child: Text(percentage, style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100,
                      fontFamily: Helper.interSemiBold,
                      color: isNightModeActive() ? ColorName.whiteColor : ColorName.darkGreyColor))
                )

              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 6, bottom: 3),
              child: Divider(color: isNightModeActive() ? ColorName.dividerColor2 : ColorName.dividerColor, height: 0.9),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget sliderView() {
    return Slider(
      value: homeController.mindfulnessLevel.value,
      min: 0,
      max: 1,
      onChanged: (value) {
        homeController.mindfulnessLevel.value = value;
      },
    );
  }*/

  Widget sunImageView(String sunImage, BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width + 500,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 1000),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: Transform.scale(
            scale: 1.5,
            key: ValueKey(sunImage),
            child: Image.asset(
              sunImage,
              //key: ValueKey(sunImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }



  Widget welcomeLabelView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Jake.",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: Helper.interSemiBold,
                  fontWeight: FontWeight.w600,
                  color: ColorName.whiteColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Today is a fresh start, breathe it in.",
                style: TextStyle(
                  fontFamily: Helper.interSemiBold,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  letterSpacing: -0.5,
                  color: ColorName.whiteColor,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget topRightImgView() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(Helper.lightning,height: 17, color: isNightModeActive() ? ColorName.redColor  : ColorName.whiteColor),
            SizedBox(width: 8,),
            Text(
              "${(homeController.mindfulnessLevel.value * 100).toInt()}%",
              style: TextStyle(
                fontSize: 18,
                fontFamily: Helper.tiemposReguler,
                fontWeight: FontWeight.bold,
                color: isNightModeActive() ? ColorName.redColor  : ColorName.whiteColor,
              ),
            ),
            SizedBox(width: 10,),
            SizedBox(
              width: 30,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(Helper.profile),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget percentagePopView(BuildContext context) {
    return SizedBox (
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Stack (
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Text (
                "${(homeController.mindfulnessLevel.value * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: Helper.tiemposReguler,
                  fontWeight: FontWeight.w500,
                  color: ColorName.whiteColor,
                ),
              ),
              Text (
                "Normal",
                style: TextStyle (
                  fontSize: 18,
                  color: ColorName.whiteColor,
                ),
              ),
            ],
          ),

          bottomPopMenuView(),

        ],
      ),
    );
  }

  PopupMenuItem<int> _buildPopupMenuItem(int index, String imageName, String text) {
    return PopupMenuItem<int> (
      value: index,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text (
            text,
            style: TextStyle(fontSize: 12, color: isNightModeActive()? ColorName.whiteColor :
            Colors.brown.shade700, fontFamily: Helper.interSemiBold, fontWeight: FontWeight.w300),
          ),
          SizedBox(width: 10),
          Container (
              height: 30,
              width: 30,
              padding: EdgeInsets.all(index == 1 ? 2 : 5),
              decoration: BoxDecoration (
                color: ColorName.darkGreyColor,
                shape: BoxShape.circle
              ),
              // child: Icon(Icons.sunny),
              // child: Icon(Icons.sunny_snowing),
              // child: Icon(Icons.wb_sunny_outlined),
              child: Image.asset("assets/images/$imageName", fit: BoxFit.contain)
          )
          // Icon(icon, color: Colors.brown.shade700, size: 20),

        ],
      ),
    );
  }


  PopupMenuItem<int> sunSetPopMenuItem(int index, String text, IconData sunImage) {
    return PopupMenuItem<int> (
      value: index,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text (
            text,
            style: TextStyle(fontSize: 12, color: Colors.brown.shade700, fontFamily: Helper.interSemiBold, fontWeight: FontWeight.w300),
          ),
          SizedBox(width: 10),
          Container (
              height: 30,
              width: 30,
              padding: EdgeInsets.all(index == 1 ? 2 : 5),
              decoration: BoxDecoration (
                color: ColorName.darkGreyColor,
                shape: BoxShape.circle
              ),
              // child: Icon(Icons.sunny),
              // child: Icon(Icons.sunny_snowing),
              child: Icon(sunImage, size: 20, color: ColorName.whiteColor),
          )
          // Icon(icon, color: Colors.brown.shade700, size: 20),

        ],
      ),
    );
  }

  Widget bottomPopMenuView() {
    return Positioned (
      right: 25,
      bottom: 0,
      child: PopupMenuButton<int> (
        icon: Icon(homeController.showPopMenu.value ? Icons.remove_circle_outline_rounded : Icons.add_circle_outline_rounded,
            size: 30, color: ColorName.whiteColor),
        color: isNightModeActive() ? ColorName.bg4Pop : Colors.white.withOpacity(0.85), // Transparent menu background
        elevation: 5,
        shape: RoundedRectangleBorder (
          borderRadius: BorderRadius.circular(15),
        ),
        offset: Offset(-10, -160),
        position: PopupMenuPosition.over,
        onOpened: () {
          homeController.showPopMenu(true);
        },
        onCanceled: () {
          homeController.showPopMenu(false);
        },
        itemBuilder: (context) => [
          _buildPopupMenuItem(1, "pop_meditate.png", "Meditate"),
          _buildPopupMenuItem(2, "pop_trending_up.png", "Trend"),
          _buildPopupMenuItem(3, "pop_play_arrow.png", "Start Activity"),
        ],
        onSelected: (value) {
          if (value == 1) {
            print("Meditate Clicked");
          } else if (value == 2) {
            print("Trend Clicked");
          } else if (value == 3) {
            print("Start Activity Clicked");
          }
        },
      ),
    );
  }


  Widget bgImageModeWisePopMenuView() {
    return SafeArea (
      child: Align (
        alignment: Alignment.topRight,
        child: Padding (
          padding: EdgeInsets.only(right: 8, top: 50),
          child: PopupMenuButton<int> (
            icon: Icon(getSelectedThemeIcon(homeController.selectedBgImageCount.value),
                size: 30, color: ColorName.whiteColor),
            color: Colors.white.withOpacity(0.85), // Transparent menu background
            elevation: 5,
            shape: RoundedRectangleBorder (
              borderRadius: BorderRadius.circular(15),
            ),
            offset: Offset(-20, 0),
            position: PopupMenuPosition.under,
            // position: PopupMenuPosition.over,
            onOpened: () {
              // homeController.showPopMenu1(true);
            },
            onCanceled: () {
              // homeController.showPopMenu1(false);
            },
            itemBuilder: (context) => [
              sunSetPopMenuItem(1, "Morning", Icons.wb_sunny_outlined),
              sunSetPopMenuItem(2, "Afternoon", Icons.sunny),
              sunSetPopMenuItem(3, "Evening", Icons.sunny_snowing),
              sunSetPopMenuItem(4, "Night Mode", Icons.nightlight_round_outlined),
            ],
            onSelected: (value) {
              homeController.selectedBgImageCount.value = value;
              if (value == 1) {
                print("Meditate Clicked");

              } else if (value == 2) {
                print("Trend Clicked");
              } else if (value == 3) {
                print("Start Activity Clicked");
              } else if(value == 4) {

              }
            },
          ),
        ),
      ),
    );
  }

  bool isNightModeActive(){
    return homeController.selectedBgImageCount.value == 4;
  }

  String getBackGroundImage(int selectedIndex) {
    return selectedIndex == 1 ? Helper.bg1 :
    selectedIndex == 2 ? Helper.bg2 :
    selectedIndex == 3 ? Helper.bg3 : Helper.bg4;
  }

  IconData getSelectedThemeIcon(int selectedIndex) {
    return selectedIndex == 1 ? Icons.wb_sunny_outlined :
    selectedIndex == 2 ? Icons.sunny :
    selectedIndex == 3 ? Icons.sunny_snowing : Icons.nightlight_round_outlined;
  }
}
