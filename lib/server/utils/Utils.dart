import 'dart:developer';

import 'package:haversine_distance/haversine_distance.dart';

class Utils {
  static getDistance(Map userLoc, Map myLoc, double distance) {
    HaversineDistance hv = HaversineDistance();
    Location locationUser = Location(userLoc['latitude'], userLoc['longitude']);
    Location myLocation = Location(myLoc['latitude'], myLoc['longitude']);
    var distanceF = hv.haversine(myLocation, locationUser, Unit.METER).floor();
    if (distanceF <= distance) {
      return [distanceF, true];
    }
    return [distanceF, false];
  }

  static makeUsersComparator(
      List myGames, List myPlatforms, List friendGames, List friendPlatforms) {
    var coincidence = checkCoincidences(friendGames, myGames) +
        checkCoincidences(friendPlatforms, myPlatforms);
    return coincidence;
  }

  static int checkCoincidences(List l1, List l2) =>
      (l1 + l2).toSet().toList().length;
}
