import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/navigation_controller.dart';

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
    await Future.delayed(const Duration(milliseconds: 2000), () {
      navigation.setSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B262C), Color(0xFF0F4C75), Color(0xFF3282B8)],
            )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.5,
                      child: Image.asset('assets/images/GammApp.png'),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
