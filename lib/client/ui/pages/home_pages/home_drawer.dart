import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/authentication_controller.dart';
import 'package:gamma/client/ui/controllers/navigation_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../views/user.dart';
import '../views/friends.dart';
import '../../pages/authentication/login_page.dart';
import 'discover.dart';
import 'home.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  // ignore: prefer_final_fields
  NavigationController navigation_controller = Get.find();
  AuthenticationController authentication_controller = Get.find();
  final List<IconData> _icons = [
    Icons.home,
    Icons.person,
    Icons.person_search,
    Icons.settings,
    Icons.logout
  ];
  final List<String> _titles = [
    'Página Principal',
    'Perfil',
    'Amigos',
    'Ajustes',
    'Cerrar Sesión'
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListTileTheme(
              selectedColor: Colors.blue,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _titles.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return (index == 0)
                        ? UserAccountsDrawerHeader(
                            accountName: Text(
                              'Username',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            accountEmail: Text(
                              'username@user.com',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            currentAccountPicture: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/user.png',
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                            ),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://t4.ftcdn.net/jpg/04/09/70/87/360_F_409708782_HxuxOH8f7xSmj5p4ygbAbuJE74vGGj2N.jpg'),
                                  fit: BoxFit.cover),
                            ),
                          )
                        : Obx(
                            () => ListTile(
                              selected:
                                  navigation_controller.drawerTiles[index - 1],
                              selectedTileColor:
                                  const Color.fromARGB(166, 41, 15, 171),
                              leading: Icon(
                                _icons[index - 1],
                                color: Colors.black,
                              ),
                              title: Text(
                                _titles[index - 1],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                navigation_controller.selectTile = index - 1;
                                Navigator.pop(context);
                                (index - 1 == 4)
                                    ? authentication_controller.logged = false
                                    : {};
                              },
                            ),
                          );
                  }),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 10.0, 50, 30),
                child: GestureDetector(
                  onTap: () {
                    log('Start matchmaking...');
                  },
                  child: Container(
                    width: 180,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF2D15AB),
                          spreadRadius: 3,
                          blurRadius: 8,
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage("assets/images/matchmaking.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Emparéjame',
                        style: TextStyle(
                          fontSize: 22,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
