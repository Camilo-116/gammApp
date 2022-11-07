import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/data/models/post_model.dart';
import '../../../../server/data/models/user_model.dart';
import '../views/friends_page.dart';
import '../views/user_page.dart';
import 'discover.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserController user_controller = Get.find();
  PostController post_controller = Get.find();
  AuthenticationController auth_controller = Get.find();
  int _currentIndex = 0;
  String _title = 'GammApp';

  @override
  Widget build(BuildContext context) {
    UserModel user = user_controller.users[0];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    log('Height: $height');
    log('Width: $width');

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

    final screens = [
      _postListView(post_controller.posts, width, height),
      Obx(() => UserPage(user: user_controller.users[0])),
      const DiscoverGamers(),
      FriendsPage(user: user_controller.users[0]),
      Obx(() => UserPage(user: user_controller.users[0])),
    ];

    var padding = EdgeInsets.symmetric(horizontal: width * 0.015, vertical: 0);

    return Scaffold(
        key: scaffoldKey,
        extendBody: true,
        backgroundColor: const Color.fromARGB(255, 34, 15, 57),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                auth_controller.logOut();
                log('Logout button pressed');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
          toolbarHeight: (56 / 756) * height,
          backgroundColor: const Color.fromARGB(255, 37, 19, 60),
          shadowColor: const Color.fromARGB(255, 80, 41, 131),
          title: Text(
            _title,
            style: GoogleFonts.hind(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: (24 / 360) * width,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: screens[_currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          child: Container(
              height: height * 0.08,
              margin: EdgeInsets.symmetric(
                horizontal: (20 / 360) * width,
                vertical: (5 / 756) * height,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 8, 25),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: -10,
                    blurRadius: 60,
                    color: Colors.black.withOpacity(.20),
                    offset: const Offset(0, 25),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (3 / 360) * width,
                  vertical: (10 / 756) * height,
                ),
                child: GNav(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 900),
                    iconSize: width * 0.12,
                    activeColor: const Color.fromARGB(255, 235, 65, 229),
                    color: const Color.fromARGB(255, 129, 117, 139),
                    onTabChange: (index) {
                      if (index == 0) {
                        _title = 'GammApp';
                      } else if (index == 1) {
                        _title = 'Create Post';
                      } else if (index == 2) {
                        _title = 'Discover';
                      } else if (index == 3) {
                        _title = 'Friends';
                      } else if (index == 4) {
                        _title = 'Profile';
                      }
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    tabs: [
                      GButton(
                        icon: Icons.home,
                        padding: padding,
                      ),
                      GButton(
                        icon: Icons.add_box_rounded,
                        padding: padding,
                      ),
                      GButton(
                        icon: Icons.location_on,
                        padding: padding,
                      ),
                      GButton(
                        icon: Icons.people_alt,
                        padding: padding,
                      ),
                      GButton(
                        icon: Icons.person,
                        padding: padding,
                      ),
                    ]),
              )),
        ));
  }

  Widget _postListView(List<PostModel> posts, double width, double height) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _postView(index, width, height),
              (index < posts.length - 1)
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postAuthor(index, width, height),
        _postImage(index, width, height),
        _postActions(index, width),
        _postCaption(index, width, height),
      ],
    );
  }

  Widget _postAuthor(int index, double width, double height) {
    double _imageSize = (44 / 360) * width;
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
              width: _imageSize,
              height: _imageSize,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child:
                  Image.asset(post_controller.posts[index].user.profilePhoto),
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
                              user: post_controller.posts[index].user,
                            )),
                  );
                },
                child: Text(
                  post_controller.posts[index].user.username,
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
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onDoubleTap: () {
          post_controller.likePost(index);
        },
        child: Image.network(
          post_controller.posts[index].picture,
          width: (100 / 360) * width,
          height: (300 / 756) * height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _postActions(int index, double width) {
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
                    post_controller.likes[index]
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post_controller.likes[index]
                        ? const Color.fromARGB(255, 235, 65, 229)
                        : Colors.white,
                    size: (24 / 360) * width,
                  ),
                ),
                onPressed: () {
                  post_controller.likePost(index);
                },
              ),
              Obx(
                () => Text(
                  (post_controller.posts[index].likes > 1000000)
                      ? '${num.parse((post_controller.posts[index].likes / 1000000).toStringAsFixed(1))} M'
                      : (post_controller.posts[index].likes > 1000)
                          ? '${num.parse((post_controller.posts[index].likes / 1000).toStringAsFixed(1))} k'
                          : '${post_controller.posts[index].likes}',
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
                (post_controller.posts[index].comments > 1000000)
                    ? '${num.parse((post_controller.posts[index].comments / 1000000).toStringAsFixed(1))} M'
                    : (post_controller.posts[index].comments > 1000)
                        ? '${num.parse((post_controller.posts[index].comments / 1000).toStringAsFixed(1))} k'
                        : '${post_controller.posts[index].comments}',
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
                (post_controller.posts[index].shares > 1000000)
                    ? '${num.parse((post_controller.posts[index].shares / 1000000).toStringAsFixed(1))} M'
                    : (post_controller.posts[index].shares > 1000)
                        ? '${num.parse((post_controller.posts[index].shares / 1000).toStringAsFixed(1))} k'
                        : '${post_controller.posts[index].shares}',
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        (8 / 360) * width,
        0,
        (12 / 756) * height,
        (8 / 360) * width,
      ),
      child: Text(
        post_controller.posts[index].caption,
        style: GoogleFonts.hind(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: (16 / 360) * width,
        ),
      ),
    );
  }
}
