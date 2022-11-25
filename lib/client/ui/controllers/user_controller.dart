import 'dart:async';
import 'dart:developer';
import 'dart:math' as m;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/animation.dart';
import 'package:gamma/client/ui/controllers/static_info_controller.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../../server/models/user_model.dart';
import '../../../server/services/GpsService.dart';
import '../../../server/services/UserBasicService.dart';
import '../../../server/services/UserExtendedService.dart';

class UserController extends GetxController {
  UserBasicService userBasicService = UserBasicService();
  UserExtendedService userExtendedService = UserExtendedService();
  GpsService gpsService = GpsService();

  Rx<UserModel> _loggedUser = UserModel(id: '', username: '', email: '').obs;
  var _loggedUserID = "".obs;
  var _loggedUserUsername = "".obs;
  var _loggedUserEmail = "".obs;
  var _loggedUserStatus = 'Offline'.obs;
  var _loggedUserPicture = "".obs;
  var _loggedUserFriends = <UserModel>[].obs;
  var _loggedUserFriendsReady = false.obs;
  var _loggedUserGames = <Map<String, String>>[].obs;
  var _loggedUserPlatforms = <Map<String, String>>[].obs;
  var _loggedUserDiscoverUsers = <List<dynamic>>[].obs;

  /// Getter for the logged user
  UserModel get loggedUser => _loggedUser.value;

  /// Getter for the logged user's ID
  String get loggedUserID => _loggedUserID.value;

  /// Getter for status
  String get loggedUserStatus => _loggedUserStatus.value;

  /// Getter for email
  String get loggedUserEmail => _loggedUserEmail.value;

  /// Getter for username
  String get loggedUserUsername => _loggedUserUsername.value;

  /// Getter for picture
  String get loggedUserPicture => _loggedUserPicture.value;

  /// Getter for friends
  List<UserModel> get loggedUserFriends => _loggedUserFriends.value;

  /// Getter for friends ready indicator
  bool get loggedUserFriendsReady => _loggedUserFriendsReady.value;

  /// Getter for games
  List<Map<String, String>> get loggedUserGames => _loggedUserGames.value;

  /// Getter for platforms
  List<Map<String, String>> get loggedUserPlatforms =>
      _loggedUserPlatforms.value;

  /// Getter for discover users
  List<dynamic> get loggedUserDiscoverUsers => _loggedUserDiscoverUsers.value;

  /// Setter for the logged user
  set loggedUser(UserModel user) => _loggedUser.value = user;

  /// Possible statuses
  var status = ['Online', 'Offline', 'Busy', 'Away', 'Invisible'];

  @override
  onInit() {
    super.onInit();
    // var _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    //   await getFriends(_loggedUser.id);
    // });
  }

  /// This method is used to get a user from the database given its [String] uuid.
  /// Returns a [UserModel] with the user data.
  Future<UserModel> getUserbyUUID(String uuid) async {
    UserModel user = UserModel(id: '', username: '', email: '');
    await userBasicService.getUserByUUID(uuid).then((u) async {
      u.setValues(await userExtendedService.getUserByUUID(u.extendedId!));
      user = u;
    }).catchError((onError) => log('Error getting user: $onError'));
    return user;
  }

  /// This method is used to execute all required actions to log in a user.
  ///
  /// Receives the [String] username of the user.
  Future<void> logUser(String username) async {
    _loggedUserFriendsReady.value = false;
    UserModel user = await userBasicService.getUserByUsername(username);
    bool haveGPS = await Geolocator.isLocationServiceEnabled();
    late LocationPermission _permission;
    if (haveGPS) {
      _permission = await Geolocator.checkPermission();
    }
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
    }
    var pos = await Geolocator.getCurrentPosition();
    log('Mi posicion es: $pos');
    await gpsService.addPositionToUser(
        user.extendedId!, pos.latitude, pos.longitude);
    user.setValues(await userExtendedService.getUserByUUID(user.extendedId!));
    _loggedUser.value = user;
    _loggedUserID.value = user.id;
    _loggedUserUsername.value = user.username;
    _loggedUserEmail.value = user.email;
    _loggedUserPicture.value = user.profilePhoto;
    _loggedUserDiscoverUsers.value = [
      await userBasicService.getMatchmaking(
          user.id, user.extendedId!, user.friends, user.games, user.platforms)
    ];
    log('Discover users: ${_loggedUserDiscoverUsers.value}');
    log('Ok');
    _loggedUserGames.value = user.games;
    _loggedUserPlatforms.value = user.platforms;
    if (user.status == 'Offline') {
      await userBasicService.updateUserBasic(username, {'status': 'Online'});
      _loggedUserStatus.value = 'Online';
    }
    _loggedUserFriends.value = await getFriends(loggedUser.id).then((value) {
      _loggedUserFriendsReady.value = true;
      return value;
    });
    StaticInfo.init();
  }

  /// This method is used to execute all required actions to log out a user.
  Future<void> logOutUser() async {
    await userBasicService
        .updateUserBasic(loggedUserUsername, {'status': 'Offline'});
    UserModel _loggedUser = UserModel(id: '', username: '', email: '');
    var _loggedUserID = "".obs;
    var _loggedUserUsername = "".obs;
    var _loggedUserEmail = "".obs;
    var _loggedUserStatus = 'Offline'.obs;
    var _loggedUserPicture = "".obs;
    var _loggedUserFriends = <UserModel>[].obs;
    log('User logged out');
  }

  /// This method is used to resume the activity of the logged user.
  Future<void> userResumed() async {
    await userBasicService
        .updateUserBasic(loggedUser.username, {'status': 'Online'});
    _loggedUserStatus.value = 'Online';
  }

  /// This method is used to pause the activity of the logged user.
  Future<void> userInactive() async {
    await userBasicService
        .updateUserBasic(loggedUser.username, {'status': 'Away'});
    _loggedUserStatus.value = 'Away';
  }

  void _initStatus() {
    for (var friend in _loggedUserFriends) {
      friend.status = status[m.Random().nextInt(status.length)];
    }
  }

  /// THis method is used to refresh the logged user friends list.
  Future<void> refreshFriends(String uuid) async {
    log('Refreshing friends');
    getFriends(uuid).then((friends) {
      _loggedUserFriendsReady.value = false;
      _loggedUserFriends.value = friends;
      _loggedUserFriendsReady.value = true;
    });
  }

  /// This method is used to change the status of the logged user.
  ///
  /// Receives the [String] status of the user.
  Future<void> changeStatus(String status) async {
    UserModel user = loggedUser;
    user.status = status;
    loggedUser = user;
    _loggedUserStatus.value = status;
    await userBasicService
        .updateUserBasic(loggedUser.username, {'status': status});
  }

  /// This method checks if a user with a certain [String] username exists in the database.
  ///
  /// Returns a [bool] with the result.
  Future<bool> checkUser(String username) async {
    bool exists = false;
    await userBasicService.getUserByUsername(username).then((value) {
      exists = true;
    }).catchError((onError) => log('$onError'));
    return exists;
  }

  /// Add a [UserModel] friend to the list of friends of the logged user
  /// and the respective userExtended in the database collection.
  ///
  /// Receives a [String] uuid1 and a [String] uuid2, that refer to each user
  /// to be friended.
  /// Return a [Future<bool>] that indicates if the operation was successful.
  Future<bool> becameFriends(String uuid1, String uuid2) async {
    var newLoggedUserFriends = _loggedUserFriends;
    var extendedUuid1 = await userBasicService.getExtendedId(uuid1);
    var extendedUuid2 = await userBasicService.getExtendedId(uuid2);

    UserModel friend = await userBasicService.getUserByUUID(uuid2);
    friend.setValues(await userExtendedService.getUserByUUID(extendedUuid2));

    var added2 = await userExtendedService.addFriend(
        uuid1, extendedUuid2, await userBasicService.getUsername(uuid2));
    var added1 = await userExtendedService.addFriend(
        uuid2, extendedUuid1, await userBasicService.getUsername(uuid1));

    newLoggedUserFriends.add(friend);
    _loggedUserFriends = newLoggedUserFriends;

    return added1 && added2;
  }

  /// This method is used to get the list of friends of a specific user.
  ///
  /// Receives a [String] username, that refers to the user whose friends
  /// list is going to be retrieved.
  /// Return a [Future<List<UserModel>>] that contains the list of friends
  /// of the user.
  Future<List<UserModel>> getFriends(String uuid) async {
    var friends = <UserModel>[];
    await userBasicService.getExtendedId(uuid).then((uuid) async {
      await userExtendedService.getUserByUUID(uuid).then((extendedUser) async {
        if (extendedUser['friends'].length > 0) {
          for (var friend in extendedUser['friends']) {
            await userBasicService
                .getUserByUUID(friend['uuidBasic'])
                .then((friendUser) async {
              friendUser.setValues(await userExtendedService
                  .getUserByUUID(friendUser.extendedId!));
              friends.add(friendUser);
            }).catchError((e) => log('Cannot get friend\nError: $e'));
          }
        } else {
          log('No friends');
        }
      });
    });

    return friends;
  }

  /// This method is to get the ids involved in the feed construction.
  ///
  /// Return a [Future<List<String>>] that contains the list of users ids involved in the feed construction.
  List<String> getFeedIds() {
    var feedIDs = <String>[];
    feedIDs = loggedUserFriends.map((e) => e.id).toList();
    feedIDs.add(loggedUserID);

    return feedIDs;
  }

  /// This method is used to add a new [String] post id to the LikedPosts
  /// attribute of the logged user(UserModel) and to the LikedPosts field of
  /// the collection.
  Future<void> likePost(String postId, bool newLike) async {
    var newLoggedUser = loggedUser;
    if (newLike) {
      newLoggedUser.likedPosts.add(postId);
    } else {
      newLoggedUser.likedPosts.remove(postId);
    }
    loggedUser = newLoggedUser;
    await userExtendedService.postLikeClicked(
        loggedUser.extendedId!, postId, newLike);
  }

  /// This method is used to retrieve the games of a specific user given its [String] uuid.
  ///
  /// Return a [List<Map<String, Object>>] with the games of the user.
  /// If the user has no games, return an empty list.
  Future<List<Map<String, String>>> getUserGamesbyUUID(String uuid) async {
    var games = <Map<String, String>>[];
    await userBasicService.getExtendedId(uuid).then((uuid) async {
      await userExtendedService.getUserByUUID(uuid).then((extendedUser) async {
        if (extendedUser['games'].length > 0) {
          for (var game in extendedUser['games']) {
            games.add({
              'name': game['name'],
              'icon_url': game['icon_url'],
            });
          }
        } else {
          log('No games');
        }
      });
    });

    return games;
  }

  /// This method is used to retrieve the platforms of a specific user given its [String] uuid.
  ///
  /// Return a [List<Map<String, Object>>] with the platforms of the user.
  /// If the user has no platforms, return an empty list.
  Future<List<Map<String, String>>> getUserPlatformsbyUUID(String uuid) async {
    var platforms = <Map<String, String>>[];
    await userBasicService.getExtendedId(uuid).then((uuid) async {
      await userExtendedService.getUserByUUID(uuid).then((extendedUser) async {
        if (extendedUser['platforms'].length > 0) {
          for (var platform in extendedUser['platforms']) {
            platforms.add(platform);
          }
        } else {
          log('No platforms');
        }
      });
    });

    return platforms;
  }

  /// This method is used to add a platform to the Field platforms of the logged
  /// user and the extended user user in the database.
  ///
  /// Receives a [int] index that refers to the index of the platform in the
  /// StaticInfo.platforms list.
  /// Return a [Future<bool>] that indicates if the operation was successful.
  Future<bool> addPlatform(int index) async {
    var platform = StaticInfo.platforms[index];

    var added =
        await userExtendedService.addPlatform(loggedUser.extendedId!, platform);

    if (added) {
      loggedUser.platforms.add(platform);
      _loggedUserPlatforms.value = loggedUser.platforms;
      _loggedUser.refresh();
    }

    return added;
  }

  /// This method is used to add a game to the Field games of the logged
  /// user and the extended user user in the database.
  ///
  /// Receives a [int] index that refers to the index of the game in the
  /// StaticInfo.games list.
  /// Return a [Future<bool>] that indicates if the operation was successful.
  Future<bool> addGame(int index) async {
    var game = {
      'name': StaticInfo.games[index]['name'] as String,
      'icon_url': StaticInfo.games[index]['icon_url'] as String
    };

    var added = await userExtendedService.addGame(loggedUser.extendedId!, game);

    if (added) {
      loggedUser.games.add(game);
      _loggedUserGames.value = loggedUser.games;
      _loggedUser.refresh();
    }

    return added;
  }

  /// This method is used to remove a platform from the Field platforms of the logged
  /// user and the extended user user in the database.
  ///
  /// Receives a [int] index that refers to the index of the platform in the
  /// StaticInfo.platforms list.
  /// Return a [Future<bool>] that indicates if the operation was successful.
  Future<bool> removePlatform(int index) async {
    var platform = {
      'logo_url': StaticInfo.platforms[index]['logo_url'] as String,
      'name': StaticInfo.platforms[index]['name'] as String
    };

    var removed = await userExtendedService.removePlatform(
        loggedUser.extendedId!, platform);

    if (removed) {
      loggedUser.platforms.remove(loggedUser.platforms
          .firstWhere((p) => p['name'] == platform['name']));
      _loggedUserPlatforms.value = loggedUser.platforms;
      _loggedUser.refresh();
    }

    return removed;
  }

  /// This method is used to remove a game from the Field games of the logged
  /// user and the extended user user in the database.
  ///
  /// Receives a [int] index that refers to the index of the game in the
  /// StaticInfo.games list.
  /// Return a [Future<bool>] that indicates if the operation was successful.
  Future<bool> removeGame(int index) async {
    var game = {
      'name': StaticInfo.games[index]['name'] as String,
      'icon_url': StaticInfo.games[index]['icon_url'] as String
    };

    var removed =
        await userExtendedService.removeGame(loggedUser.extendedId!, game);

    if (removed) {
      loggedUser.games.remove(
          loggedUser.games.firstWhere((g) => g['name'] == game['name']));
      _loggedUserGames.value = loggedUser.games;
      _loggedUser.refresh();
    }

    return removed;
  }

  /// This method is used to update the logged user's about field
  ///
  /// Receives a [String] newAbout that is the new about field of the user.
  /// Return a [Future<bool>] that indicates if the operation was successful.
  Future<bool> updateAbout(String newAbout) async {
    var updated =
        await userExtendedService.updateAbout(loggedUser.extendedId!, newAbout);

    if (updated) {
      loggedUser.about = newAbout;
      _loggedUser.refresh();
    }

    return updated;
  }
}
