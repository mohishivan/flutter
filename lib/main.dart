import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surya_tracker/Ui/bottom_bar_view.dart';
import 'Ui/home_screen.dart';
import 'Utils/global.dart';

void main() {
  runApp(const MyApp());
  Global.topBarThemeSettings();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp (
      title: 'Surya Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData (
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomBarView(),
    );
  }
}

