import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/data/models/post_model.dart';
import '../../../../server/data/models/user_model.dart';
import '../views/friends_page.dart';
import '../views/user_page.dart';
import '../views/settings.dart';
import 'discover.dart';
import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserController user_controller = Get.find();
  PostController post_controller = Get.find();
  int _currentIndex = 0;
  String _title = 'GammApp';

  @override
  Widget build(BuildContext context) {
    UserModel user = user_controller.users[0];
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
      _postListView(post_controller.posts),
      UserPage(user: user),
      DiscoverGamers(),
      FriendsPage(user: user),
      UserPage(user: user),
    ];

    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);

    return Scaffold(
        key: scaffoldKey,
        extendBody: true,
        backgroundColor: Color.fromARGB(255, 34, 15, 57),
        appBar: AppBar(
          toolbarHeight: 56,
          backgroundColor: Color.fromARGB(255, 37, 19, 60),
          shadowColor: Color.fromARGB(255, 80, 41, 131),
          title: Text(
            _title,
            style: GoogleFonts.hind(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: screens[_currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 26, 8, 25),
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: -10,
                    blurRadius: 60,
                    color: Colors.black.withOpacity(.20),
                    offset: Offset(0, 25),
                  )
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                child: GNav(
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 900),
                    iconSize: 48,
                    activeColor: Color.fromARGB(255, 235, 65, 229),
                    color: Color.fromARGB(255, 129, 117, 139),
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

  Widget _postListView(List<PostModel> posts) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _postView(index),
              (index < posts.length - 1)
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Divider(
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(
                      height: 15,
                    ),
            ],
          );
        });
  }

  Widget _postView(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postAuthor(index),
        _postImage(index),
        _postActions(index),
        _postCaption(index),
      ],
    );
  }

  Widget _postAuthor(int index) {
    const double _imageSize = 44;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 5, 12, 2),
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
              padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
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
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Align(
                alignment: AlignmentDirectional(1, 0),
                child:
                    Icon(Icons.keyboard_control, color: Colors.white, size: 24),
              ),
            )
          ]),
        )
      ],
    );
  }

  Widget _postImage(int index) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onDoubleTap: () {
          post_controller.likePost(index);
        },
        child: Image.network(
          post_controller.posts[index].picture,
          width: 100,
          height: 300,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _postActions(int index) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                        ? Color.fromARGB(255, 235, 65, 229)
                        : Colors.white,
                    size: 24,
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
                      fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  print('Make a comment...');
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
                    fontSize: 16),
              ),
              IconButton(
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  print('Share pressed ...');
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
                    fontSize: 16),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _postCaption(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 12, 8),
      child: Text(
        post_controller.posts[index].caption,
        style: GoogleFonts.hind(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}
