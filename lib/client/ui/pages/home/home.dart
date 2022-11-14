import 'dart:developer';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamma/client/ui/pages/views/feed/create_post.dart';
import 'package:gamma/client/ui/pages/views/user/user_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../controllers/authentication_controller.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import '../views/discover.dart';
import '../views/feed/feed.dart';
import '../views/friends_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  UserController userController = Get.find();
  PostController postController = Get.find();
  AuthenticationController authController = Get.find();
  int _currentIndex = 0, _prevIndex = 0;

  final List<String> _titles = [
    'GammApp',
    'Hacer una Publicación',
    'Descubre',
    'Amigos',
    'Perfil de Usuario'
  ];

  var screens = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var padding = EdgeInsets.symmetric(horizontal: width * 0.015, vertical: 0);

    var screens = _fillScreens();

    return FutureBuilder<List>(
        future: screens,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return Scaffold(
                key: scaffoldKey,
                extendBody: true,
                backgroundColor: const Color.fromARGB(255, 34, 15, 57),
                appBar: AppBar(
                  actions: [
                    IconButton(
                      onPressed: () async {
                        authController.logOut();
                        await userController.logOutUser();
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
                    _titles[_currentIndex],
                    style: GoogleFonts.hind(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (24 / 360) * width,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                ),
                body: AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => SlideTransition(
                    // Make the child slide in from the right when it appears if _prevIndex > _currentIndex and from the left if _prevIndex < _currentIndex
                    position: Tween<Offset>(
                      begin: _prevIndex < _currentIndex
                          ? const Offset(1, 0)
                          : const Offset(-1, 0),
                      end: const Offset(0, 0),
                    ).animate(animation),
                    child:
                        _getPage(snapshot.data! as List<Widget>, _currentIndex),
                  ),
                  layoutBuilder: (currentChild, previousChildren) =>
                      currentChild!,
                  child:
                      _getPage(snapshot.data! as List<Widget>, _currentIndex),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: SafeArea(
                  child: Container(
                      height: height * 0.08,
                      margin: EdgeInsets.symmetric(
                        horizontal: (20 / 360) * width,
                        vertical: (5 / 756) * height,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 26, 8, 25),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
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
                            activeColor:
                                const Color.fromARGB(255, 235, 65, 229),
                            color: const Color.fromARGB(255, 129, 117, 139),
                            onTabChange: (index) async {
                              setState(() {
                                _prevIndex = _currentIndex;
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
          } else {
            return Stack(children: [
              Container(
                color: const Color.fromARGB(255, 34, 15, 57),
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 99, 46, 162),
                ),
              ),
            ]);
          }
        });
  }

  Future<List<Widget>> _fillScreens() async {
    // log('Logged User: ${userController.loggedUser.toMap()}');
    var screens = <Widget>[];
    await userController
        .getFriends(userController.loggedUser.id)
        .then((res) async {
      var friendsIDs =
          userController.loggedUserFriends.map((e) => e.id).toList();
      await postController.getFeed(friendsIDs).then((res) async {
        postController.fillLikes(userController.loggedUser.likedPosts);
        screens = <Widget>[
          Feed(feed: postController.feed),
          CreatePost(),
          const DiscoverGamers(),
          FriendsPage(friends: userController.loggedUserFriends),
          UserPage()
        ];
      }).catchError((onError) => log('Error getting feed: $onError'));
    }).catchError((onError) => log('Error getting friends: $onError'));

    return screens;
  }

  Widget _getPage(List<Widget> screens, int index) {
    return screens[index];
  }
}
