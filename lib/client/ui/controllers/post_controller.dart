import 'dart:developer';
import 'dart:math';

import 'package:get/get.dart';

import '../../../server/data/models/post_model.dart';

class PostController extends GetxController {
  var status = ['Online', 'Offline', 'Busy', 'Away', 'Invisible'];
  // ignore: prefer_final_fields
  var _posts = <PostModel>[].obs;
  var _likes = <bool>[].obs;

  RxList<bool> get likes => _likes;

  @override
  onInit() {
    super.onInit();
    _initializeLikes();
  }

  _initializeLikes() {
    _likes = List.filled(_posts.length, false, growable: true).obs;
  }

  RxList<PostModel> get posts => _posts;

  void addPost(PostModel post) {
    _posts.add(post);
    _likes.add(false);
  }

  void likePost(int index) {
    if (_likes[index]) {
      togglePostLike = index;
      PostModel post = _posts[index];
      post.likes--;
      _posts[index] = post;
    } else {
      togglePostLike = index;
      PostModel post = _posts[index];
      post.likes++;
      _posts[index] = post;
    }
  }

  set togglePostLike(int index) => _likes[index] = !_likes[index];
}
