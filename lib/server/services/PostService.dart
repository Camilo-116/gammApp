import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

/// This class represents the service that allows to interact with the Post collection.
/// Which contains the posts stored in the database.
class PostService {
  /// This method is used to get the feed for a user(userExtended) using its [String] uuid.
  ///
  /// Returns a [Future<List>] of posts to fill the feed of the logged User.
  Future<List> getFeed(String uuidUser) async {
    List feed = [];
    await FirebaseFirestore.instance
        .collection('userExtended')
        .doc(uuidUser)
        .get()
        .then((res) async {
      var friends = res.data()!['friends'];
      await Future.forEach(friends, (friendUUID) async {
        Map dataUser = {};
        String id = friendUUID.toString().trim();
        await FirebaseFirestore.instance
            .collection('userBasic')
            .doc(id)
            .get()
            .then((res) async {
          dataUser['username'] = res.data()!['username'];
          await FirebaseFirestore.instance
              .collection('posts')
              .where('uuidUser', isEqualTo: id)
              .get()
              .then((res) async {
            dataUser['posts'] = res.docs;
            feed.add(dataUser);
          });
        });
      });
    });
    return feed;
  }

  /// This method is used to get the [List<Post>] of a user with a given [String] username.
  Future<List<Map>?> getUserPosts(String uuidUser) async {
    List<Map> posts = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uuidUser', isEqualTo: uuidUser)
        .get()
        .then((res) {
      for (var element in res.docs) {
        var data = element.data();
        data['id'] = element.id;
        posts.add(data);
      }
    }).catchError((onError) =>
            log('Error getting posts of user $uuidUser: $onError'));
    return posts;
  }

  /// This is method is for deleting a [Post] given its [String] uuid.
  ///
  /// Returns a [bool] indicating if the post was deleted or not.
  Future<bool> deletePost(String uuidPost) async {
    bool deleted = true;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(uuidPost)
        .delete()
        .catchError((e) => deleted = false);
    return deleted;
  }

  /// This method is used to add a [Post] to the database.
  ///
  /// Receives a [Map<String, dynamic>] with the data of the post and returns a [String] with the uuid of the post.
  Future<String> addPost(Map<String, dynamic> post) async {
    String postId = "";
    await FirebaseFirestore.instance.collection('posts').add(post).then((res) {
      postId = res.id;
    }).catchError((onError) {
      log('Error adding post to database: $onError');
    });
    return postId;
  }

  /// Function that returns a [List<Map>] with all posts stored in the database.
  Future<List<Map>> getPosts() async {
    List<Map> posts = [];
    await FirebaseFirestore.instance.collection('posts').get().then((res) {
      res.docs.forEach((element) {
        posts.add(element.data());
      });
    });
    return posts;
  }

  /// This method is used to get all the posts made by specific users.
  ///
  /// Receives a [List<String>] with the uuids of the users and returns a [List<Map>] with the posts.
  Future<List<Map>> getPostsByUsers(List<String> uuids) async {
    List<Map> posts = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uuidUser', whereIn: uuids)
        .get()
        .then((res) {
      for (var element in res.docs) {
        var data = element.data();
        data['id'] = element.id;
        posts.add(data);
      }
    }).catchError((onError) => log('Error getting posts: $onError'));
    return posts;
  }
}
