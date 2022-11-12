import 'dart:developer';

import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/server/services/PostService.dart';
import 'package:get/get.dart';

import '../../../../../server/models/post_model.dart';
import '../../../server/models/post_model.dart';

class PostController extends GetxController {
  var status = ['Online', 'Offline', 'Busy', 'Away', 'Invisible'];
  // ignore: prefer_final_fields
  var _feed = <PostModel>[].obs;
  var _likes = <bool>[].obs;

  PostService postService = PostService();
  UserController userController = Get.find<UserController>();

  RxList<bool> get likes => _likes;
  get feed => _feed;

  @override
  onInit() {
    super.onInit();
    _initializeLikes();
  }

  _initializeLikes() {
    _likes = List.filled(_feed.length, false, growable: true).obs;
  }

  void addPost(PostModel post) {
    //postService.addPost(post.toMap());
    //_posts.add(post);
    //_likes.add(false);
  }

  /*
   * This method is used to get the feed of the user
  */
  Future<void> createFeed() async {
    log('Geeting feed');
    log('The user ${userController.loggedUser.username} request the feed');
    var getFeed =
        await postService.getFeed(userController.loggedUser.extendedId);
    for (var post in getFeed) {
      _feed.add(PostModel(
          user: post['uuidUser'],
          picture: post['picture'],
          caption: post['caption'],
          postedTimeStamp: post['postedTimeStamp'],
          likes: post['likes'],
          comments: post['comments'],
          shares: post['shares']));
    }
    log('Got feed');
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

  set togglePostLike(int index) => _likes[index] = !_likes[index];
}
