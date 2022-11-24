import 'package:gamma/server/utils/Utils.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer' as dev;
import 'dart:math';

import '../models/user_model.dart';

/// This class represents the services that allows to interact with the userBasic collection.
/// Which contains the basic information of a user.
class UserBasicService {
  String id = "";

  HaversineDistance hv = HaversineDistance();

  /// This method is used to retrieve the [String] uuid of the extendedUser related.
  ///
  /// Receives a [String] with the uuid of the user(userBasic) to be retrieved.
  /// Returns a [Future<String>] with the uuid of the user(userExtended) related.
  Future<String> getExtendedId(String uuid) async {
    String extendedID = "";
    await FirebaseFirestore.instance
        .collection("userBasic")
        .doc(uuid)
        .get()
        .then((res) {
      if (res.exists && res.data()!.isNotEmpty) {
        extendedID = res.data()!['user_extended_uuid'];
      }
    }).catchError((e) {});
    return extendedID;
  }

  /// This method is used to get a specific user(userBasic) given its [String] username.
  ///
  /// Returns a [Future<UserModel>] of the user with the given [String] username.
  Future<UserModel> getUserByUsername(String username) async {
    String uuid = "";
    Map dataUserBasic = {};
    await FirebaseFirestore.instance
        .collection("userBasic")
        .where("username", isEqualTo: username)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        dataUserBasic = res.docs[0].data();
        uuid = res.docs[0].id;
      }
    });
    return UserModel(
        id: uuid,
        username: dataUserBasic['username'],
        email: dataUserBasic['email'],
        extendedId: dataUserBasic['user_extended_uuid']);
  }

  /// This method is used to get a specific user(userBasic) given its [String] username.
  //
  /// Returns a [Future<UserModel>] of the user with the given [String] username.
  Future<UserModel> getUserByUUID(String uuid) async {
    Map dataUserBasic = {};
    await FirebaseFirestore.instance
        .collection("userBasic")
        .doc(uuid)
        .get()
        .then((res) {
      if (res.exists && res.data()!.isNotEmpty) {
        dataUserBasic = res.data()!;
        uuid = res.id;
      }
    });
    return UserModel(
        id: uuid,
        status: dataUserBasic['status'],
        username: dataUserBasic['username'],
        email: dataUserBasic['email'],
        extendedId: dataUserBasic['user_extended_uuid']);
  }

  /// This method adds a new user(userBasic).
  ///
  /// Receives a [Map] with the data of the user to be added.
  /// Returns a [Future<String>] with the uuid of the user(userBasic) added.
  Future<String?> addUserBasic(Map userBasic) async {
    await FirebaseFirestore.instance
        .collection('userBasic')
        .add({
          'email': userBasic['email'],
          'status': userBasic['status'],
          'username': userBasic['username'],
        })
        .then((res) => id = res.id)
        .catchError((onError) => dev.log(onError));
    return id;
  }

  /// This method is used to link a user(userBasic) with a user(userExtended).
  ///
  /// Receives a [String] with the uuid of the user(userBasic) and a [String] with the uuid of the user(userExtended).
  /// At the end, the property user_extended_uuid of the userBasic is filled with the uuid of the related userExtended.
  Future<void> linkUserBasicExtended(
      String? basicId, String? extendedId) async {
    dev.log(basicId.toString());
    await FirebaseFirestore.instance
        .collection('userBasic')
        .doc(basicId)
        .update({'user_extended_uuid': extendedId});
  }

  /// This method is used to update the properties of a specific user(userBasic) given its [username].
  ///
  /// Receives a [Map] with the new data and the [username] of the user to be updated.
  /// Returns the uuid of the updated user(userBasic).
  Future<String?> updateUserBasic(
      String username, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance
        .collection("userBasic")
        .where("username", isEqualTo: username)
        .get()
        .then((res) async {
      if (res.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("userBasic")
            .doc(res.docs[0].id)
            .update(updateInfo);
      } else {
        dev.log("User not found");
      }
      id = res.docs[0].id;
    });
    return id;
  }

  /// This is the method used to retrieve the [String] username of a user given its [String] uuid.
  ///
  /// Returns a [Future<String>] with the username of the user.
  Future<String> getUsername(String uuid) async {
    String username = "";
    await FirebaseFirestore.instance
        .collection("userBasic")
        .doc(uuid)
        .get()
        .then((res) {
      if (res.exists && res.data()!.isNotEmpty) {
        username = res.data()!['username'];
      }
    }).catchError((e) => {});
    return username;
  }

  /// This method is used to retrieve the [List] of users to match of a user given its [String] basicUUID, [String] extendedUUID and [List] with his location and optional [Map] filters.
  ///
  /// Returns a [Future<List>] with the users to match.
  Future<List> getMatchmaking(String basicUUID, String extendedUUID,
      List location, List myGames, List myPlattaforms,
      {Map filter = const {"distance": 300}}) async {
    List<Map> matchmaking = [];
    List friends = [];
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(extendedUUID)
        .get()
        .then((res) async {
      if (res.exists && res.data()!.isNotEmpty) {
        friends = [basicUUID, res.data()!['friends']];
        await FirebaseFirestore.instance
            .collection('userBasic')
            .where('user_extended_uuid', whereNotIn: friends)
            .get()
            .then((res) {
          if (res.docs.isNotEmpty) {
            Future.forEach(res.docs, (element) async {
              await FirebaseFirestore.instance
                  .collection('userExtended')
                  .doc(element.data()['user_extended_uuid'])
                  .get()
                  .then((res) {
                var friend = res.data()!;
                var gamesF = friend['games'];
                var plattformsF = friend['plattforms'];
                var coincidence = Utils.checkCoincidences(gamesF, myGames) +
                    Utils.checkCoincidences(plattformsF, myPlattaforms);
                var distanceF = Utils.getDistance(
                    friend['location'], location, filter['distance']);
                if (distanceF[1] && coincidence > 0) {
                  matchmaking.add({
                    'profilePhoto': friend['profilePhoto'],
                    'games': gamesF,
                    'plattforms': plattformsF,
                    'username': element.data()['username'],
                    'distance': distanceF[0],
                  });
                }
              }).catchError((e) => []);
            });
          }
          return matchmaking;
        });
      }
      return [];
    }).catchError((e) => []);
  }
}
