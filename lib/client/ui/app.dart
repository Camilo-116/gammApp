import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/navigation_controller.dart';
import 'pages/authentication/login_page.dart';
import 'pages/loading/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GetX<NavigationController>(
          builder: (controller) {
            if (controller.splash) {
              return SplashScreen();
            }
            return LoginScreen();
          },
        ));
  }
}
