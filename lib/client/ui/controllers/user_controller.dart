import 'dart:async';
import 'dart:developer';
import 'dart:math' as m;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../server/models/user_model.dart';
import '../../../server/services/UserBasicService.dart';
import '../../../server/services/UserExtendedService.dart';

class UserController extends GetxController {
  UserBasicService userBasicService = UserBasicService();
  UserExtendedService userExtendedService = UserExtendedService();

  Rx<UserModel> _loggedUser = UserModel(id: '', username: '', email: '').obs;
  var _loggedUserID = "".obs;
  var _loggedUserUsername = "".obs;
  var _loggedUserEmail = "".obs;
  var _loggedUserStatus = 'Offline'.obs;
  var _loggedUserPicture = "".obs;
  var _loggedUserFriends = <UserModel>[].obs;
  var _loggedUserGames = <Map<String, String>>[].obs;
  var _loggedUserPlatforms = <Map<String, String>>[].obs;

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

  /// Getter for games
  List<Map<String, String>> get loggedUserGames => _loggedUserGames.value;

  /// Getter for platforms
  List<Map<String, String>> get loggedUserPlatforms =>
      _loggedUserPlatforms.value;

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
    UserModel user = await userBasicService.getUserByUsername(username);
    user.setValues(await userExtendedService.getUserByUUID(user.extendedId!));
    _loggedUser.value = user;
    _loggedUserID.value = user.id;
    _loggedUserUsername.value = user.username;
    _loggedUserEmail.value = user.email;
    _loggedUserPicture.value = user.profilePhoto;
    if (user.status == 'Offline') {
      await userBasicService.updateUserBasic(username, {'status': 'Online'});
      _loggedUserStatus.value = 'Online';
    }
    _loggedUserFriends.value = await getFriends(loggedUser.id);
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
          log('Friends: ${extendedUser['friends']}');
          for (var friend in extendedUser['friends']) {
            await userBasicService
                .getUserByUUID(friend['uuid'])
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
  Future<List<Map<String, Object>>> getUserGamesbyUUID(String uuid) async {
    var games = <Map<String, Object>>[];
    await userBasicService.getExtendedId(uuid).then((uuid) async {
      await userExtendedService.getUserByUUID(uuid).then((extendedUser) async {
        if (extendedUser['games'].length > 0) {
          for (var game in extendedUser['games']) {
            games.add(game);
          }
        } else {
          log('No games');
        }
      });
    });

    return games;
  }

  /// This method retrieves the info of the games related to a given [List<String>] of the games uuids
  ///
  /// Return a [List<Map<String, Object>>] with the games info.
  /// If the user has no games, return an empty list.
  Future<void> getGamesInfo(List<String> gamesUUIDs) async {
    var gamesInfo = gamesUUIDs.map((uuid) async =>
        await FirebaseFirestore.instance.collection('games').doc(uuid).get());
    log('Games info: $gamesInfo');
    // return gamesInfo;
  }
}
