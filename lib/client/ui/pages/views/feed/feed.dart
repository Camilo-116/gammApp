import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../server/models/post_model.dart';
import '../user/user_page.dart';

class Feed extends StatefulWidget {
  Feed({Key? key, required this.feed}) : super(key: key);

  List<PostModel> feed;

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  AuthenticationController authenticationController = Get.find();
  PostController postController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    /*
    post_controller.addPost(PostModel(
        id: 0,
        user: user_controller.users[0],
        picture: 'https://picsum.photos/seed/901/600',
        caption: "I'm a Dahmer fan",
        likes: 100000,
        comments: 4700,
        shares: 1500));
    post_controller.addPost(PostModel(
        id: 1,
        user: user_controller.users[2],
        picture:
            'https://i.picsum.photos/id/413/400/400.jpg?hmac=-4Fi-wezu1Vi5MiN26ZcAqlCXNbyBGezeISVWgPAhQc',
        caption: "OSU lover 'til the end of my days",
        likes: 2,
        comments: 0,
        shares: 1));
    post_controller.addPost(PostModel(
        id: 2,
        user: user_controller.users[1],
        picture:
            'https://i.picsum.photos/id/270/400/400.jpg?hmac=7wcLGHIwFHGv56-7wUIKXv99dcj4KfcYIsewlE1SmfA',
        caption: "Treino",
        likes: 40000,
        comments: 420,
        shares: 0));
    post_controller.addPost(PostModel(
        id: 3,
        user: user_controller.users[3],
        picture:
            'https://i.picsum.photos/id/166/400/400.jpg?hmac=cHBjLdAgtcrf9aydJi-KSu0n2BfKLNe2LcJ0WpJoso0',
        caption: "Panamá es mío",
        likes: 305948,
        comments: 6969,
        shares: 3));
        */

    return ListView.builder(
        itemCount: widget.feed.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _postView(index, width, height),
              (index < widget.feed.length - 1)
                  ? Padding(
                      padding: EdgeInsets.only(bottom: (8.0 / 756) * height),
                      child: const Divider(
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.white,
                      ),
                    )
                  : SizedBox(
                      height: (15 / 756) * height,
                    ),
            ],
          );
        });
  }

  Widget _postView(int index, double width, double height) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _postAuthor(index, width, height),
          _postCaption(index, width, height),
          _postImage(index, width, height),
          _postActions(index, width)
        ],
      ),
    );
  }

  Widget _postAuthor(int index, double width, double height) {
    PostController postController = Get.find();
    double imageSize = (44 / 360) * width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            (12 / 360) * width,
            (5 / 756) * height,
            (12 / 360) * width,
            (5 / 756) * height,
          ),
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            Container(
              width: imageSize,
              height: imageSize,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(widget.feed[index].user.profilePhoto),
            ),
            Padding(
              padding:
                  EdgeInsetsDirectional.fromSTEB((6 / 360) * width, 0, 0, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPage(
                              user: postController.feed[index].user,
                            )),
                  );
                },
                child: Text(
                  postController.feed[index].user.username,
                  style: GoogleFonts.hind(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: (16 / 360) * width,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(1, 0),
                child: Icon(Icons.keyboard_control,
                    color: Colors.white, size: (24 / 360) * width),
              ),
            )
          ]),
        )
      ],
    );
  }

  Widget _postImage(int index, double width, double height) {
    PostController postController = Get.find();
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onDoubleTap: () {
          postController.likePost(index);
        },
        child: Image.network(
          postController.feed[index].picture,
          width: (100 / 360) * width,
          height: (300 / 756) * height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _postActions(int index, double width) {
    PostController postController = Get.find();
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          (16 / 360) * width, 0, (16 / 360) * width, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Obx(
                  () => Icon(
                    postController.likes[index]
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: postController.likes[index]
                        ? const Color.fromARGB(255, 235, 65, 229)
                        : Colors.white,
                    size: (24 / 360) * width,
                  ),
                ),
                onPressed: () {
                  postController.likePost(index);
                },
              ),
              Obx(
                () => Text(
                  (postController.feed[index].likes.length > 1000000)
                      ? '${num.parse((postController.feed[index].likes.length / 1000000).toStringAsFixed(1))} M'
                      : (postController.feed[index].likes.length > 1000)
                          ? '${num.parse((postController.feed[index].likes.length / 1000).toStringAsFixed(1))} k'
                          : '${postController.feed[index].likes.length}',
                  style: GoogleFonts.hind(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: (16 / 360) * width),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                  size: (24 / 360) * width,
                ),
                onPressed: () {
                  log('Make a comment...');
                },
              ),
              Text(
                (postController.feed[index].comments.length > 1000000)
                    ? '${num.parse((postController.feed[index].comments.length / 1000000).toStringAsFixed(1))} M'
                    : (postController.feed[index].comments.length > 1000)
                        ? '${num.parse((postController.feed[index].comments.length / 1000).toStringAsFixed(1))} k'
                        : '${postController.feed[index].comments.length}',
                style: GoogleFonts.hind(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: (16 / 360) * width),
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                  size: (24 / 360) * width,
                ),
                onPressed: () {
                  log('Share pressed ...');
                },
              ),
              Text(
                (postController.feed[index].shares.length > 1000000)
                    ? '${num.parse((postController.feed[index].shares.length / 1000000).toStringAsFixed(1))} M'
                    : (postController.feed[index].shares.length > 1000)
                        ? '${num.parse((postController.feed[index].shares.length / 1000).toStringAsFixed(1))} k'
                        : '${postController.feed[index].shares.length}',
                style: GoogleFonts.hind(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: (16 / 360) * width),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _postCaption(int index, double width, double height) {
    PostController postController = Get.find();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        (8 / 360) * width,
        0,
        (12 / 756) * height,
        (8 / 360) * width,
      ),
      child: Text(
        postController.feed[index].caption,
        style: GoogleFonts.hind(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: (16 / 360) * width,
        ),
      ),
    );
  }
}
