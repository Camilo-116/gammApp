import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/server/services/PostService.dart';
import 'package:gamma/server/services/UserExtendedService.dart';
import 'package:get/get.dart';

import '../../../../../server/models/post_model.dart';
import '../../../server/models/post_model.dart';
import '../../../server/models/user_model.dart';

class PostController extends GetxController {
  var status = ['Online', 'Offline', 'Busy', 'Away', 'Invisible'];
  // ignore: prefer_final_fields
  var _feed = <PostModel>[].obs;
  var _likes = <bool>[].obs;
  var _userPosts = <PostModel>[].obs;
  var _feedReady = false.obs;

  PostService postService = PostService();
  UserExtendedService userExtendedService = UserExtendedService();

  RxList<bool> get likes => _likes;
  bool get feedReady => _feedReady.value;
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
  Future<bool> getFeed(List<String> friendsIDs) async {
    _feedReady.value = false;
    _feed.clear();
    _likes.clear();
    await postService.getPostsByUsers(friendsIDs).then((posts) {
      if (posts.isNotEmpty) {
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
      } else {
        log('No posts found');
      }
      _feedReady.value = true;
    }).catchError(
        (onError) => log('Error getting posts (Post controller): $onError'));
    return _feedReady.value;
  }

  // CORREGIR, NO RESTAR A LOS LIKES, SINO ELIMINAR AL USUARIO DE LA LISTA
  Future<bool> likePost(UserModel user, int index) async {
    if (_likes[index]) {
      togglePostLike = index;
      PostModel post = _feed[index];
      post.likes.remove(user.id);
      _feed[index] = post;
    } else {
      togglePostLike = index;
      PostModel post = _feed[index];
      post.likes.add(user.id);
      _feed[index] = post;
    }
    await postService
        .postLikeClicked(_feed[index].id!, user.id, likes[index])
        .catchError((onError) {
      if (_likes[index]) {
        togglePostLike = index;
        PostModel post = _feed[index];
        post.likes.remove(user.id);
        _feed[index] = post;
      } else {
        togglePostLike = index;
        PostModel post = _feed[index];
        post.likes.add(user.id);
        _feed[index] = post;
      }
      log('Error liking post: $onError');
    });
    return likes[index];
  }

  /// This method fills the [List<bool>] _likes with the likes of the logged user.
  ///
  /// Receives the logged User likes list.
  void fillLikes(List<String> likes) {
    for (var post in _feed) {
      if (likes.contains(post.id)) {
        _likes.add(true);
      } else {
        _likes.add(false);
      }
    }
  }

  set togglePostLike(int index) {
    _likes[index] = !_likes[index];
    _likes.refresh();
  }

  /// This method is called when the logged user logs out, it clears the post
  /// information related to said user.
  userLoggedOut() {
    _feed.clear();
    _likes.clear();
    _userPosts.clear();
  }

  /// This method is called when a user logs in, it fills the feed and related
  /// likes, as well as the user's posts.
  Future<bool> userLoggedIn(
      String uuid, List<String> feedIDs, List<String> likes) async {
    bool r1 = false, r2 = false;
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
      r1 = true;
    }).catchError(
        (onError) => log('Error getting logged user posts: $onError'));
    await getFeed(feedIDs).then((res) async {
      fillLikes(likes);
      r2 = true;
    }).catchError((onError) => log('Error getting feed: $onError'));
    return r1 && r2;
  }

  Future<bool> refreshFeed(List<String> feedIDs, List<String> likes) async {
    _feedReady.value = false;
    await getFeed(feedIDs).then((res) async {
      fillLikes(likes);
      _feedReady.value = true;
    }).catchError((onError) => log('Error getting feed: $onError'));
    return _feedReady.value;
  }
}
