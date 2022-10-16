import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/authentication_controller.dart';
import 'controllers/navigation_controller.dart';
import 'pages/authentication/login_page.dart';
import 'pages/home_pages/home.dart';
import 'pages/loading/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: GetX<AuthenticationController>(
            builder: (controller) {
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1500),
                  // transitionBuilder: (Widget child, Animation<double> animation) {
                  //   return ScaleTransition(scale: animation, child: child);
                  // },
                  child:
                      (!controller.logged) ? LoginScreen() : const HomePage());
            },
          )),
    );
  }
}
