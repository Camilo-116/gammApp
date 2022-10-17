import 'package:get/get.dart';

class NavigationController extends GetxController {
  var _splashScreen = true.obs;
  var _drawerTiles = [true, false, false, false, false].obs;

  bool get splash => _splashScreen.value;
  List<bool> get drawerTiles => _drawerTiles;

  set selectTile(int i) {
    if (i != 4) {
      _drawerTiles = RxList.filled(_drawerTiles.length, false);
      _drawerTiles[i] = true;
    } else {
      _drawerTiles = [true, false, false, false, false].obs;
    }
  }

  set setSplash(bool mode) {
    _splashScreen.value = mode;
  }

  NavigationController() {}
}
