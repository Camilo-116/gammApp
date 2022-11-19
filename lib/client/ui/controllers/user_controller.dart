import 'dart:async';
import 'dart:developer';
import 'dart:math' as m;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Getter for the logged user
  UserModel get loggedUser => _loggedUser.value;
  // Getter for the logged user's ID
  String get loggedUserID => _loggedUserID.value;
  // Getter for status
  String get loggedUserStatus => _loggedUserStatus.value;
  // Getter for email
  String get loggedUserEmail => _loggedUserEmail.value;
  // Getter for username
  String get loggedUserUsername => _loggedUserUsername.value;
  // Getter for picture
  String get loggedUserPicture => _loggedUserPicture.value;
  // Getter for friends
  List<UserModel> get loggedUserFriends => _loggedUserFriends.value;

  // Setter for the logged user
  set loggedUser(UserModel user) => _loggedUser.value = user;

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

  Future<void> userResumed() async {
    await userBasicService
        .updateUserBasic(loggedUser.username, {'status': 'Online'});
    _loggedUserStatus.value = 'Online';
  }

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

  Future<void> changeStatus(String status) async {
    UserModel user = loggedUser;
    user.status = status;
    loggedUser = user;
    _loggedUserStatus.value = status;
    await userBasicService
        .updateUserBasic(loggedUser.username, {'status': status});
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
}
