import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/MindFulModel.dart';
import '../Utils/global.dart';
import 'dart:math';

class HomeScreenController extends GetxController{
  var mindfulnessLevel = 0.1.obs;
  RxList<MindFulModel> mindFulData = <MindFulModel>[].obs;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  RxBool showPopMenu = false.obs;
  RxInt selectedBgImageCount = 1.obs;
  late Timer dataStreamTimer;

  @override
  void onInit() {
    selectedBgImageCount.value = Global.getBackGroundTimeBased();

    mindFulData.add(MindFulModel("Disengaged", DateTime.now(), "5%"));
    mindFulData.add(MindFulModel("Normal", DateTime.now().add(Duration(seconds: 5)), "15%"));
    mindFulData.add(MindFulModel("Mindful", DateTime.now().add(Duration(seconds: 8)), "25%"));

    startDataStream();
    super.onInit();
  }

  startDataStream(){
    dataStreamTimer = new Timer.periodic(Duration(seconds: 5), (Timer timer) {
      int mindFulLevel = generateMindFulLevel();
      String mood = "";
      if(mindFulLevel <= 33){
        mood = "Disengaged";
      }else if(mindFulLevel >= 34 && mindFulLevel <= 66){
        mood = "Normal";
      }else{
        mood = "Mindful";
      }

      mindFulData.insert(0,MindFulModel(mood, DateTime.now(), "${mindFulLevel}%"));
      listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 500));
      mindfulnessLevel.value = mindFulLevel/100;
    });
  }

  int generateMindFulLevel() {
    return Random().nextInt(100) + 1;
  }

  String convertTimeInFormat(DateTime datetime){
    int totalSeconds = datetime.second + datetime.minute * 60;

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedTime = "${minutes}m ${seconds}s";
    return formattedTime;
  }
}