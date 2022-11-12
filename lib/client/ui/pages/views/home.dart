import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/pages/views/user_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../controllers/authentication_controller.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import 'discover.dart';
import 'feed.dart';
import 'friends_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  UserController user_controller = Get.find();
  PostController post_controller = Get.find();
  AuthenticationController auth_controller = Get.find();
  int _currentIndex = 0;
  String _title = 'GammApp';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var padding = EdgeInsets.symmetric(horizontal: width * 0.015, vertical: 0);

    if (auth_controller.logged) {
      setState(() {
        post_controller.createFeed();
      });
    }

    final screens = [
      Feed(posts: post_controller.posts),
      UserPage(user: user_controller.loggedUser),
      const DiscoverGamers(),
      FriendsPage(user: user_controller.loggedUser),
      UserPage(user: user_controller.loggedUser),
    ];

    return Scaffold(
        key: scaffoldKey,
        extendBody: true,
        backgroundColor: const Color.fromARGB(255, 34, 15, 57),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                auth_controller.logOut();
                await user_controller.logOutUser();
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
}
