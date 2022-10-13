import 'package:get/get.dart';

class NavigationController extends GetxController {
  var _splashScreen = true.obs;

  bool get splash => _splashScreen.value;

  set setSplash(bool mode) {
    _splashScreen.value = mode;
  }

  NavigationController() {}
}
