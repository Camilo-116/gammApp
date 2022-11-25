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

  /// This method is used to get games info from the database given their names.
  ///
  /// Receives a [List<String>] names, the names of the games to be retrieved.
  /// Return a [List<Map<String,String>>] with the games' info.
  static Future<List<Map<String, String>>> getGames(List<String> names) async {
    List<Map<String, String>> games = [];
    await FirebaseFirestore.instance
        .collection("games")
        .where("name", whereIn: names)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        for (var game in res.docs) {
          games.add({
            "name": game.data()["name"],
            "icon_url": game.data()["icon_url"],
          });
        }
      }
    }).catchError((onError) => log('Error getting game: $onError'));
    return games;
  }

  /// This method is used to get platforms info from the database given their names.
  ///
  /// Receives a [List<String>] names, the names of the platforms to be retrieved.
  /// Return a [List<Map<String,String>>] with the platforms' info.
  static Future<List<Map<String, String>>> getPlatforms(
      List<String> names) async {
    List<Map<String, String>> platforms = [];
    await FirebaseFirestore.instance
        .collection("platforms")
        .where("name", whereIn: names)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        for (var platform in res.docs) {
          platforms.add({
            "name": platform.data()["name"],
            "logo_url": platform.data()["logo_url"],
          });
        }
      }
    }).catchError((onError) => log('Error getting platform: $onError'));
    return platforms;
  }
}
