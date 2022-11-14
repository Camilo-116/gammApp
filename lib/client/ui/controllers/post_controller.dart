import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/server/services/PostService.dart';
import 'package:gamma/server/services/UserExtendedService.dart';
import 'package:get/get.dart';

import '../../../../../server/models/post_model.dart';
import '../../../server/models/post_model.dart';

class PostController extends GetxController {
  var status = ['Online', 'Offline', 'Busy', 'Away', 'Invisible'];
  // ignore: prefer_final_fields
  var _feed = <PostModel>[].obs;
  var _likes = <bool>[].obs;
  var _userPosts = <PostModel>[].obs;

  PostService postService = PostService();
  UserExtendedService userExtendedService = UserExtendedService();
  UserController userController = Get.find<UserController>();

  RxList<bool> get likes => _likes;
  List<PostModel> get feed => _feed;
  List<PostModel> get userPosts => _userPosts;

  @override
  onInit() {
    super.onInit();
    _initializeLikes();
  }

  _initializeLikes() {
    _likes = List.filled(_feed.length, false, growable: true).obs;
  }

  Future<bool> createPost(PostModel post) async {
    bool result = false;
    await postService.addPost(post.toMap(true)).then((uuidPost) {
      post.id = uuidPost;
      _userPosts.add(post);
      result = true;
    }).catchError((onError) {
      log('Error creating post: $onError');
    });
    return result;
  }

  /// This method is used to refresh the feed of the looged user.
  /// It receives a [List<String>] with the uuids of the logged user's friends
  /// and adds each friend's posts to the [List<PostModel>] _feed.
  Future<void> getFeed(List<String> friendsIDs) async {
    _feed.clear();
    _likes.clear();
    await postService.getPostsByUsers(friendsIDs).then((posts) {
      for (var post in posts) {
        _feed.add(
          PostModel(
            id: post['id'],
            userID: post['uuidUser'],
            userUsername: post['username'],
            userProfilePicture: post['profilePicture'],
            picture: post['picture'],
            caption: post['caption'],
            postedTimeStamp: post['postedTimeStamp'].toDate(),
            likes: List<String>.from(post['likes']),
            comments: List<Map<String, dynamic>>.from(post['comments']),
            shares: List<String>.from(post['shares']),
          ),
        );
      }
    }).catchError((onError) => log('Error getting posts: $onError'));
  }

  // CORREGIR, NO RESTAR A LOS LIKES, SINO ELIMINAR AL USUARIO DE LA LISTA
  void likePost(int index) {
    if (_likes[index]) {
      togglePostLike = index;
      PostModel post = _feed[index];
      // post.likes--;
      _feed[index] = post;
    } else {
      togglePostLike = index;
      PostModel post = _feed[index];
      // post.likes++;
      _feed[index] = post;
    }
  }

  /// This method fills the [List<bool>] _likes with the likes of the logged user.
  ///
  /// Receives the logged User likes list.
  void fillLikes(List<String> likes) {
    for (var post in _feed) {
      if (likes.contains(post.userID)) {
        _likes.add(true);
      } else {
        _likes.add(false);
      }
    }
  }

  set togglePostLike(int index) => _likes[index] = !_likes[index];

  userLoggedOut() {
    _feed.clear();
    _likes.clear();
    _userPosts.clear();
  }

  userLoggedIn(String uuid) async {
    await postService.getUserPosts(uuid).then((posts) {
      _userPosts.clear();
      for (var post in posts!) {
        _userPosts.add(
          PostModel(
            id: post['id'],
            userID: post['uuidUser'],
            userUsername: post['username'],
            userProfilePicture: post['profilePicture'],
            picture: post['picture'],
            caption: post['caption'],
            postedTimeStamp: post['postedTimeStamp'].toDate(),
            likes: List<String>.from(post['likes']),
            comments: List<Map<String, dynamic>>.from(post['comments']),
            shares: List<String>.from(post['shares']),
          ),
        );
      }
    });
  }
}
