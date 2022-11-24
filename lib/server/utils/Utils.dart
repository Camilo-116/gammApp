import 'package:haversine_distance/haversine_distance.dart';

class Utils {
  static getDistance(List userLoc, List myLoc, double distance) {
    HaversineDistance hv = HaversineDistance();
    Location locationUser = Location(userLoc[0], userLoc[1]);
    Location myLocation = Location(myLoc[0], myLoc[1]);
    var distanceF = hv.haversine(myLocation, locationUser, Unit.METER).floor();
    if (distanceF <= distance) {
      return [distance, true];
    }
    return [distance, false];
  }

  static int checkCoincidences(List l1, List l2) =>
      (l1 + l2).toSet().toList().length;
}
