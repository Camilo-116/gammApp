import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../authentication/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NavigationController navigation = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _popSplash();
  }

  _popSplash() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {
      navigation.setSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Buenas'),
    ));
  }
}
