import 'package:gamma/server/services/staticInfoService.dart';

class StaticInfo {
  static List<Map<String, Object>> games = [];
  static List<Map<String, String>> platforms = [];

  static void init() async {
    await StaticInfoService.getAllGames().then((value) => games = value);
    await StaticInfoService.getAllPlatforms()
        .then((value) => platforms = value);
  }
}
