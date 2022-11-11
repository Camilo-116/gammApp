import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotificationService {
  Map typeNotification = {'friendRequest': 0, 'friendRequestAccepted': 1};

  /*
   * This method is used to send a friend request and add to the notification pipeline
   * @param sender: User who sent the request
   * @param recieverUsername: Username who received the request
   * @param recieverUUID: Id of the user who received the request
   * @return bool: true if the request was sent, false otherwise
   */
  Future<bool> addUsernameNotification(
      String senderUUID, String recieverUsername, String recieverUUID) async {
    return FirebaseFirestore.instance
        .collection('userNotification')
        .add({
          'senderUUID': senderUUID,
          'recieverUsername': recieverUsername,
          'recieverUUID': recieverUUID,
          'typeNotification': typeNotification['friendRequest'],
        })
        .then((value) => true)
        .catchError((onError) {
          print(onError);
          return false;
        });
  }

  /*
   * This method is used to send a friend request has been accepted and add to the notification pipeline
   * @param senderUsername: Username who sent the request
   * @param recieverUUID: Id of the user who sent the request to be accepted
   * @return bool: true if the request was sent, false otherwise
   */
  Future<bool> requestAcceptedNotification(
      String senderUsername, String recieverUUID) async {
    return await FirebaseFirestore.instance
        .collection('userNotification')
        .add({
          'senderUsername': senderUsername,
          'recieverUUID': recieverUUID,
          'typeNotification': typeNotification['friendRequestAccepted'],
        })
        .then((value) => true)
        .catchError((onError) {
          print(onError);
          return false;
        });
  }
}
