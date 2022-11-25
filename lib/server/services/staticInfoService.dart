import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

/// This class allows to interact with the games collection and platform collection.
class StaticInfoService {
  /// This method is used to retrieve all games from the database.
  ///
  /// Return a [Future<List<Map<String,String>>>] with all games as maps.
  static Future<List<Map<String, Object>>> getAllGames() async {
    List<Map<String, Object>> games = [];
    await FirebaseFirestore.instance.collection("games").get().then((res) {
      for (var game in res.docs) {
        games.add({
          "name": game.data()["name"],
          "icon_url": game.data()["icon_url"],
          "platforms": game.data()["platforms"],
          "release_date": game.data()["release_date"],
        });
      }
    }).catchError((onError) => log('Error getting games: $onError'));
    return games;
  }

  /// This method is used to retrieve all platforms from the database.
  ///
  /// Return a [Future<List<Map<String,String>>>] with all platforms as maps.
  static Future<List<Map<String, String>>> getAllPlatforms() async {
    List<Map<String, String>> platforms = [];
    await FirebaseFirestore.instance.collection("platforms").get().then((res) {
      for (var platform in res.docs) {
        platforms.add({
          "name": platform.data()["name"],
          "logo_url": platform.data()["logo_url"],
        });
      }
    }).catchError((onError) => log('Error getting platforms: $onError'));
    return platforms;
  }

  /// This method is used
}
