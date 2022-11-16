import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:get/get_connect/http/src/utils/utils.dart';

/// This class represents the service that allows to interact with the notifications collection.
/// Which contains the notifications stored in the database.
class UserNotificationService {
  Map typeNotification = {'friendRequest': 0, 'friendRequestAccepted': 1};

  /*
  Friend request status
    0: Pending
    1: Accepted
  */

  /// This method is used to send a friend request and add it to the notification pipeline
  ///
  /// Receives the [String] uuid of the user that sends the request,
  /// and the [String] uuid of the user that receives the request, as well as his [String] username.
  /// Returns a [Future<bool>] indicating whether the notification was sent or not.
  Future<bool> addUsernameNotification(
      String senderUUID,
      String? senderExtendedUUID,
      String? recieverUsername,
      String? recieverUUID) async {
    log('Add username notification ...');
    return FirebaseFirestore.instance.collection('userNotifications').add({
      'senderUUID': senderUUID,
      'senderExtenedUUID': senderExtendedUUID,
      'recieverUsername': recieverUsername,
      'recieverUUID': recieverUUID,
      'typeNotification': typeNotification['friendRequest'],
    }).then((value) async {
      return await FirebaseFirestore.instance
          .collection('userExtended')
          .doc(senderExtendedUUID)
          .update({
            "friends": {
              recieverUUID: {'username': recieverUsername, 'status': 0}
            },
          })
          .then((value) => true)
          .catchError((onError) => false);
    }).catchError((onError) {
      print(onError);
      return false;
    });
  }

  /// This method is used to send a friend request has been accepted and add to the notification pipeline.
  ///
  /// Receives the [String] uuid of the user that sent the request,
  /// and the [String] uuid of the user that received the request.
  /// Returns a [Future<bool>] indicating whether the request was sent or not.
  Future<bool> requestAcceptedNotification(String senderUsername,
      String senderUUID, String senderExtendedUUID, String recieverUUID) async {
    log('Request accepted notification ...');
    await FirebaseFirestore.instance
        .collection('userNotification')
        .where('senderUUID', isEqualTo: recieverUUID)
        .where('recieverUUID', isEqualTo: senderUUID)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        Future.forEach(res.docs, (doc) {
          FirebaseFirestore.instance
              .collection('userNotification')
              .doc(doc.id)
              .delete();
        });
      }
    });

    return await FirebaseFirestore.instance.collection('userNotification').add({
      'senderUsername': senderUsername,
      'recieverUUID': recieverUUID,
      'typeNotification': typeNotification['friendRequestAccepted'],
    }).then((value) async {
      return await FirebaseFirestore.instance
          .collection('userExtended')
          .doc(recieverUUID)
          .update({
        'friends': {
          senderUUID: {'username': senderUsername, 'status': 1},
        }
      }).then((res) async {
        return await FirebaseFirestore.instance
            .collection('userExtended')
            .doc(senderExtendedUUID)
            .update({
              'friends': {
                recieverUUID: {'username': senderUsername, 'status': 1},
              }
            })
            .then((res) => true)
            .catchError((onError) => false);
      }).catchError((onError) => false);
    }).catchError((onError) {
      print(onError);
      return false;
    });
  }

  /// This method is used to get the notifications of a user.
  ///
  /// Receives the [String] uuid of the user.
  /// Returns a [Stream<QuerySnapshot>] with the notifications of the user.
  Future<Stream<QuerySnapshot>> getNotifications(String uuid) async {
    return FirebaseFirestore.instance
        .collection('userNotification')
        .where('recieverUUID', isEqualTo: uuid)
        .snapshots();
  }
}
