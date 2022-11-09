import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  /*
  * This method is used to get the feed of a given username
  * @param uuidUser: uuid of the user
  * @return List: Feed of the username
  */
  Future<List?> getFeed(String uuidUser) async {
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

  /*
  * This is method is for deleting a post given the uuid
  * @param uuidPost: uuid of the post
  * @return bool: true if the post was deleted, false otherwise
  */
  Future<bool> deletePost(String uuidPost) async {
    bool deleted = true;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(uuidPost)
        .delete()
        .catchError((e) => deleted = false);
    return deleted;
  }

  /*
  * This method is used to add a post to the database
  * @param post: Map with the post data
  */
  Future<String> addPost(Map<String, dynamic> post) async {
    String postId = "";
    await FirebaseFirestore.instance.collection('posts').add(post).then((res) {
      postId = res.id;
    });
    return postId;
  }

  /*
   * Function that returns a list of all posts
   * @return List<Map> All posts
   */
  Future<List<Map>> getPosts() async {
    List<Map> posts = [];
    await FirebaseFirestore.instance.collection('posts').get().then((res) {
      res.docs.forEach((element) {
        posts.add(element.data());
      });
    });
    return posts;
  }
}
