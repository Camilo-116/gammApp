import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:get/get_connect/http/src/utils/utils.dart';

/// This class represents the service that allows to interact with the notifications collection.
/// Which contains the notifications stored in the database.
class UserNotificationService {
  Map typeNotification = {'friendRequest': 0, 'friendRequestAccepted': 1};

  Future<bool> checkIfMatch(String senderUUID, String receiverUUID) async {
    log('SENDING ($senderUUID) TO ($receiverUUID)');
    return await FirebaseFirestore.instance
        .collection('userNotification')
        .where('receiverUUID', isEqualTo: senderUUID)
        .where('senderUUID', isEqualTo: receiverUUID)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        log('MATCH FOUND');
        res.docs[0].reference.delete();
        return true;
      } else {
        log('NO MATCH FOUND');
        return false;
      }
    });
  }

  /// This method is used to send a friend request and add it to the notification pipeline
  ///
  /// Receives the [String] uuid of the user that sends the request,
  /// and the [String] uuid of the user that receives the request, as well as his [String] username.
  /// Returns a [Future<bool>] indicating whether the notification was sent or not.
  Future<bool> addUsernameNotification(
    String senderUsername,
    String senderUUID,
    String senderExtendedUUID,
    String? receiverUsername,
    String? receiverUUID,
    String? receiverExtendedUUID,
  ) async {
    log('Add username notification ...');
    return FirebaseFirestore.instance
        .collection('userNotification')
        .add({
          'senderUsername': senderUsername,
          'senderUUID': senderUUID,
          'senderExtendedUUID': senderExtendedUUID,
          'receiverUsername': receiverUsername,
          'receiverUUID': receiverUUID,
          'receiverExtendedUUID': receiverExtendedUUID,
          'typeNotification': typeNotification['friendRequest'],
        })
        .then((value) => true)
        .catchError((onError) {
          print(onError);
          return false;
        });
  }

  /// This method is used to send a friend request has been accepted and add to the notification pipeline.
  ///
  /// Receives the [String] uuid of the user that sent the request,
  /// and the [String] uuid of the user that received the request.
  /// Returns a [Future<bool>] indicating whether the request was sent or not.
  Future<bool> requestAcceptedNotification(
    String senderUsername,
    String senderUUID,
    String senderExtendedUUID,
    String receiverUsername,
    String receiverUUID,
    String receiverExtendedUUID,
  ) async {
    log('Request accepted notification ...');
    log('Request accepted notification added (Reciever : (${receiverUsername})  -> Sender : (${senderUsername})})...');
    return await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(receiverExtendedUUID)
        .update({
      "friends": FieldValue.arrayUnion([
        {
          "username": senderUsername,
          "uuidBasic": senderUUID,
          "uuidExtended": senderExtendedUUID,
        }
      ])
    }).then((res) async {
      log('Request accepted notification added (Sender -> Receiver)...');
      return await FirebaseFirestore.instance
          .collection('userExtended')
          .doc(senderExtendedUUID)
          .update({
            'friends': FieldValue.arrayUnion([
              {
                "username": receiverUsername,
                "uuidBasic": receiverUUID,
                "uuidExtended": receiverExtendedUUID,
              }
            ])
          })
          .then((res) => true)
          .catchError((onError) => false);
    }).catchError((onError) => false);
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
