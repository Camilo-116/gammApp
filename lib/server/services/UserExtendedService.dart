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
          'profilePhoto': 'assets/images/user.png',
          'about': userDescription['about'],
          'coverPhoto': userDescription['coverPhoto'],
          'games': [],
          'platforms': [],
          'friends': List<Map>,
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
}
