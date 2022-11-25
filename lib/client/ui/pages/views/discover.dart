import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gamma/server/models/user_model.dart';
import 'package:gamma/server/services/StorageService.dart';
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
  StorageService storage = StorageService();

  int _discoverIndex = 0;

  @override
  void initState() {
    super.initState();
    swipeableStackController = SwipeableCardSectionController();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var discoverUsers = userController.loggedUserDiscoverUsers;

    String games = '';
    if (discoverUsers[_discoverIndex]['games'].length > 0) {
      games =
          'Juegos favoritos de ${discoverUsers[_discoverIndex]['username']}: \n';
      for (var game in discoverUsers[_discoverIndex]['games']) {
        games += '${game['name']}';
        games +=
            (game != discoverUsers[_discoverIndex]['games'].last) ? ', ' : '';
      }
      games += '.';
    } else {
      games = 'Este usuario no ha indicado sus juegos favoritos :c';
    }

    String platforms = '';
    if (discoverUsers[_discoverIndex]['platforms'].length > 0) {
      platforms = 'Plataformas que frecuenta: \n';
      for (var platform in discoverUsers[_discoverIndex]['platforms']) {
        platforms += '${platform['name']}';
        platforms +=
            (platform != discoverUsers[_discoverIndex]['platforms'].last)
                ? ', '
                : '';
      }
      platforms += '.';
    } else {
      platforms = 'Este usuario no ha indicado sus plataformas regulares >:c';
    }

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
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: (8.0 / 756) * width),
                          child: Text(
                            discoverUsers[_discoverIndex]['username']
                                .toString(),
                            style: GoogleFonts.hind(
                              color: Colors.white,
                              fontSize: width * (20 / 360),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: (8.0 / 756) * width),
                          child: Text(
                            discoverUsers[_discoverIndex]['status'].toString(),
                            style: GoogleFonts.hind(
                              color: Colors.white,
                              fontSize: width * (16 / 360),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        height: (300 / 756) * height,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: FutureBuilder(
                          future: storage.downloadURL(
                              discoverUsers[_discoverIndex]['profilePhoto']),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData && !snapshot.hasError) {
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-0.8, 0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: (8.0 / 756) * height),
                          child: Text(
                            games,
                            style: GoogleFonts.hind(
                                fontSize: (18 / 360) * width,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-0.8, 0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: (8.0 / 756) * height),
                          child: Text(
                            platforms,
                            style: GoogleFonts.hind(
                                fontSize: (18 / 360) * width,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: const Color.fromARGB(255, 34, 15, 57),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.person_add,
                                  color:
                                      const Color.fromARGB(255, 235, 65, 229),
                                  size: (48 / 360) * width,
                                ),
                                onPressed: () async {
                                  UserModel user = userController.loggedUser;
                                  log('Add ...');
                                  var isMatch = await userNotificationService
                                      .checkIfMatch(
                                          user.id, 'OeXZbU6zU455O9pjtLKs');
                                  if (isMatch) {
                                    log('Match');
                                    await userNotificationService
                                        .requestAcceptedNotification(
                                            user.username,
                                            user.id,
                                            user.extendedId ?? "",
                                            'Dembouz',
                                            'OeXZbU6zU455O9pjtLKs',
                                            'NB01rxyWHrsAeMAZJEWq');
                                  } else {
                                    log('Waiting for match');
                                    await userNotificationService
                                        .addUsernameNotification(
                                            user.username,
                                            user.id,
                                            user.extendedId ?? "",
                                            'elpapitodelbackend',
                                            'GAMkU892j2Wfr0oNhou8',
                                            'J0CRaMcYwcHSPRyI0bnB');
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.navigate_next_rounded,
                                  color:
                                      const Color.fromARGB(255, 235, 65, 229),
                                  size: (48 / 360) * width,
                                ),
                                onPressed: () {
                                  log(discoverUsers.length.toString());
                                  setState(() {
                                    (_discoverIndex < discoverUsers.length - 1)
                                        ? _discoverIndex++
                                        : _discoverIndex = 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
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
