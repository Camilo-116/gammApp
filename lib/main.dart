import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:gamma/client/ui/controllers/navigation_controller.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:get/get.dart';

import 'client/ui/app.dart';
import 'client/ui/controllers/user_controller.dart';

void main() {
  Get.put(NavigationController());
  Get.put(AuthenticationController());
  Get.put(UserController());
  Get.put(PostController());
  runApp(const MyApp());
}
