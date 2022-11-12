import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/client/ui/pages/views/home.dart';
import 'package:get/get.dart';

import 'controllers/authentication_controller.dart';
import 'controllers/navigation_controller.dart';
import 'pages/authentication/login_page.dart';
import 'pages/views/feed.dart';
import 'pages/matchmaking/matchmaking_queue.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        //Execute the code here when user come back the app.
        //In my case, I needed to show if user active or not,
        log('User came back');
        await userController.userResumed();
        break;
      case AppLifecycleState.paused:
        //Execute the code the when user leave the app
        log('User away');
        await userController.userInactive();
        break;
      case AppLifecycleState.detached:
        //Execute the code the when user close the app
        log('User closed the app... Proceding to logout');
        await userController.logOutUser();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var node = FocusNode();
    return WillPopScope(
      onWillPop: _beforeExitApp,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(node);
        },
        child: GetMaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: GetX<AuthenticationController>(
              builder: (controller) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: (!controller.logged) ? LoginScreen() : const Home());
              },
            )),
      ),
    );
  }

  Future<bool> _beforeExitApp() async {
    UserController userController = Get.find();
    // Get.back();
    // return false;
    log('Exiting app');
    await userController.logOutUser();
    return true;
  }
}
