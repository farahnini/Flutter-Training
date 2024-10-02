import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sps/screens/home_screen.dart';
import 'package:sps/screens/login_screen.dart';
import 'package:sps/utils/sharedpreferences_utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  final storageUtils = SharedpreferencesUtils();

  @override
  void initState(){
    super.initState();
    storageUtils.init();
    Future.delayed(const Duration(seconds: 3), (){
      if (storageUtils.getStorageToken.isNotEmpty){
       // get to HomeScreen
        Get.to(() => HomeScreen());

      } else {
        Get.to(() => LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:   LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFFEA3799),
          size: 100,
        ),
      ),
    );
  }
}