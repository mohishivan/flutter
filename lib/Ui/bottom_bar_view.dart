import 'package:flutter/material.dart';
import 'package:surya_tracker/Ui/home_screen.dart';
import 'package:surya_tracker/Utils/colors.dart';

class BottomBarView extends StatelessWidget {
  const BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Column(
        children: [

          Expanded(child: HomeScreen()),

          Container (
            height: 67,
            color: ColorName.bottomBgColor,
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bottomIconView("home.png"),
                bottomIconView("meditate.png"),
                bottomIconView("community.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomIconView(String imageName) {
    return Image.asset("assets/images/$imageName", height: 45, width: 45);
  }

}
