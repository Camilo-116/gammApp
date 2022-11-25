import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

/// This class represents the services that allows to interact with the userExtended collection.
/// Which contains the extra information of a user.
class UserExtendedService {
  /// This method is used to retrieve a specific user(userExtended) from the database.
  ///
  /// Receives a [String] with the uuid of the user(userExtended) to be retrieved.
  /// Returns a [Future<Map>] with the data of the user(userExtended).
  Future<Map> getUserByUUID(String uuid) async {
    Map<String, dynamic> dataUserExtended = {};
    await FirebaseFirestore.instance
        .collection("userExtended")
        .doc(uuid)
        .get()
        .then((res) {
      if (res.exists && res.data()!.isNotEmpty) {
        dataUserExtended = res.data()!;
        dataUserExtended['id'] = res.id;
      }
    }).catchError((e) => {});
    return dataUserExtended;
  }

  /// This method adds a new user(userExtended).
  ///
  /// Receives a [Map] with the extra data of the user to be added and a [String] with the uuid of the related userBasic.
  /// Returns a [Future<String>] with the uuid of the user(userExtended) added.
  Future<String> addUserExtended(
      String documentUserId, Map userDescription) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .add({
          'user_uuid': documentUserId,
          'name': userDescription['name'],
          'profilePhoto': 'users_media/user.png',
          'about': userDescription['about'],
          'likedPosts': List<String>.empty(growable: true),
          'games': [],
          'platforms': List<Map<String, String>>.empty(growable: true),
          'friends': List<Map<String, Map>>.empty(growable: true),
        })
        .then((value) => value.id)
        .catchError((onError) => "");
  }

  /// This method adds a new friend to the friends list of a specific user(userExtended).
  ///
  /// Receives a [String] with the uuid of the user(userExtended),
  /// a [String] with the uuid of the friend(userBasic) to be added and its [String] username.
  /// Returns a [Future<bool>] indicating if the friend was succesfully added or not.
  Future<bool> addFriend(
      String uuid, String extendedFriendUUID, String friendUsername) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuid)
        .update({
          'friends': FieldValue.arrayUnion([
            {
              "extended_uuid": extendedFriendUUID,
              "username": friendUsername,
            }
          ])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<void> postLikeClicked(
      String extendedUUID, String postId, bool newLikeStatus) async {
    if (newLikeStatus) {
      await FirebaseFirestore.instance
          .collection('userExtended')
          .doc(extendedUUID)
          .update({
            'likedPosts': FieldValue.arrayUnion([postId])
          })
          .then((value) => true)
          .catchError((onError) => false);
    } else {
      await FirebaseFirestore.instance
          .collection('userExtended')
          .doc(extendedUUID)
          .update({
            'likedPosts': FieldValue.arrayRemove([postId])
          })
          .then((value) => true)
          .catchError((onError) => false);
    }
  }

  /// This method is used to add a platform to the field platforms
  ///
  /// Receives a [String] with the uuid of the user(userExtended) and a [Map] with the platform to be added.
  /// Returns a [Future<bool>] indicating if the platform was succesfully added or not.
  Future<bool> addPlatform(String uuid, Map platform) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuid)
        .update({
          'platforms': FieldValue.arrayUnion([platform])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }

  /// This method is used to add a game to the field games
  ///
  /// Receives a [String] with the uuid of the user(userExtended) and a [Map] with the game to be added.
  /// Returns a [Future<bool>] indicating if the game was succesfully added or not.
  Future<bool> addGame(String uuid, Map game) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuid)
        .update({
          'games': FieldValue.arrayUnion([game])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }

  /// This method is used to remove a platform from the field platforms
  ///
  /// Receives a [String] with the uuid of the user(userExtended) and a [Map] with the platform to be removed.
  /// Returns a [Future<bool>] indicating if the platform was succesfully removed or not.
  Future<bool> removePlatform(String uuid, Map platform) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuid)
        .update({
          'platforms': FieldValue.arrayRemove([platform])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }

  /// This method is used to remove a game from the field games
  ///
  /// Receives a [String] with the uuid of the user(userExtended) and a [Map] with the game to be removed.
  /// Returns a [Future<bool>] indicating if the game was succesfully removed or not.
  Future<bool> removeGame(String uuid, Map game) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuid)
        .update({
          'games': FieldValue.arrayRemove([game])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }

  /// This method is used to update the about field of a user(userExtended)
  ///
  /// Receives a [String] with the uuid of the user(userExtended) and a [String] with the new about.
  /// Returns a [Future<bool>] indicating if the about was succesfully updated or not.
  Future<bool> updateAbout(String uuid, String newAbout) async {
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuid)
        .update({
          'about': newAbout,
        })
        .then((value) => true)
        .catchError((onError) => false);
  }
}
