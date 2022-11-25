import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

/// This class represents the service that allows to interact with the GPS.
/// Which contains the locations of the users in the database
class GpsService {
  /// This method is used to set the location of a user with a given [String] uuid.
  /// and the [double] latitude and [double] longitude.
  Future<bool> addPositionToUser(
      String uuidExtendeUser, double latitude, double longitude) async {
    bool added = false;
    await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuidExtendeUser)
        .set({
          'lastPosition': {
            'latitude': latitude,
            'longitude': longitude,
          }
        }, SetOptions(merge: true))
        .then((res) => added = true)
        .catchError(
            (onError) => log('Error adding position to user: $onError'));
    return added;
  }

  Future<Map> getLastLocation(String uuidExtendeUser) async {
    Map location = {};
    await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuidExtendeUser)
        .get()
        .then((res) {
      if (res.exists) {
        location = res.data()!['lastPosition'];
      }
    }).catchError((onError) => log('Error getting last location: $onError'));
    return location;
  }
}
