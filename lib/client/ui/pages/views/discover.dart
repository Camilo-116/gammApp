import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gamma/server/models/user_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import '../../../../server/services/UserNotificationService.dart';
import '../../controllers/user_controller.dart';

class DiscoverGamers extends StatefulWidget {
  const DiscoverGamers({Key? key}) : super(key: key);

  @override
  _DiscoverGamersState createState() => _DiscoverGamersState();
}

class _DiscoverGamersState extends State<DiscoverGamers> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SwipeableCardSectionController swipeableStackController;

  UserController userController = Get.find();
  UserNotificationService userNotificationService = UserNotificationService();

  @override
  void initState() {
    super.initState();
    swipeableStackController = SwipeableCardSectionController();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 34, 15, 57),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: const Color.fromARGB(255, 34, 15, 57),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: (400 / 756) * height,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Image.network(
                          'https://picsum.photos/seed/788/600',
                          width: (100 / 360) * width,
                          height: (100 / 756) * height,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.person_add,
                              color: const Color.fromARGB(255, 235, 65, 229),
                              size: (30 / 360) * width,
                            ),
                            onPressed: () async {
                              UserModel user = userController.loggedUser;
                              log('Add ...');
                              await userNotificationService
                                  .addUsernameNotification(
                                      user.username,
                                      user.id,
                                      user.extendedId ?? "",
                                      'Dembouz',
                                      'OeXZbU6zU455O9pjtLKs',
                                      'NB01rxyWHrsAeMAZJEWq');
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.navigate_next_rounded,
                              color: Colors.white,
                              size: (30 / 360) * width,
                            ),
                            onPressed: () {
                              log('Next');
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-0.9, 0),
                        child: Text(
                          'Nombre de Usuario',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.hind(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: (18 / 360) * width),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-0.8, 0),
                        child: Text(
                          'Juego favorito:  Rocket League\nRango: Supersonic Legend\nPlataforma: PlayStation 5',
                          style: GoogleFonts.hind(
                              fontSize: (14 / 360) * width,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
