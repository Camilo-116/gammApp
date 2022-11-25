import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/post_controller.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/client/ui/pages/views/friends_page.dart';
import 'package:gamma/server/services/StorageService.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../server/models/user_model.dart';

class UserPage extends StatefulWidget {
  UserPage({
    this.userUUID,
    Key? key,
  }) : super(key: key);
  String? userUUID;
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // final double coverHeight = 280;
  final double profileHeight = 120;

  UserController userController = Get.find();
  PostController postController = Get.find();
  StorageService storage = StorageService();

  var user;
  var games;
  var platforms;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (widget.userUUID != null &&
        widget.userUUID != userController.loggedUserID) {
      user = userController.getUserbyUUID(widget.userUUID!);

      // games = userController.getUserGamesbyUUID(widget.userUUID!);
      // platforms = userController.getUserPlatformsbyUUID(widget.userUUID!);
    } else {
      games = userController.loggedUserGames;
      platforms = userController.loggedUserPlatforms;
      // platforms = userController.getPlatformsInfo(userController.loggedUser.platforms);
    }

    return (widget.userUUID != null &&
            widget.userUUID != userController.loggedUserID)
        ? FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                UserModel user = snapshot.data as UserModel;
                log('User: ${user.toMap()}');
                return Scaffold(
                  backgroundColor: const Color.fromARGB(255, 34, 15, 57),
                  body: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: (10 / 756) * height),
                        child: buildCover(user: user, width, height),
                      ),
                      buildAccountStats(user: user, width, height),
                      buildAction(user: user, width, height),
                      buildContent(user: user, width, height),
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  ),
                );
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
            },
          )
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 34, 15, 57),
            body: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: (10 / 756) * height),
                  child: buildCover(width, height),
                ),
                buildAccountStats(width, height),
                buildAction(width, height),
                buildContent(width, height),
                SizedBox(
                  height: height * 0.1,
                ),
              ],
            ),
          );
  }

  Widget buildCover(double width, double height, {UserModel? user}) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: (15 / 756) * height,
            left: (10 / 360) * width,
          ),
          child: CircleAvatar(
            radius: ((profileHeight / 756) * height) / 2,
            backgroundColor: const Color.fromARGB(255, 97, 24, 180),
            child: FutureBuilder(
              future: storage.downloadURL(
                  (user != null && user.id != userController.loggedUserID)
                      ? user.profilePhoto
                      : userController.loggedUserPicture),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return CircleAvatar(
                      radius: (((profileHeight / 756) * height) / 2) - 8,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: NetworkImage(
                        snapshot.data!,
                      ));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: (20 / 360) * width),
              child: (user != null && user.id != userController.loggedUserID)
                  ? Text(
                      user.username,
                      style: GoogleFonts.hind(
                        color: Colors.white,
                        fontSize: (24 / 360) * width,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Obx(() => Text(
                        userController.loggedUserUsername,
                        style: GoogleFonts.hind(
                          color: Colors.white,
                          fontSize: (24 / 360) * width,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
            ),
            Row(
              children: [
                (user != null && user.id != userController.loggedUserID)
                    ? Container(
                        margin: EdgeInsets.only(
                          left: (20 / 360) * width,
                          right: (5 / 360) * width,
                        ),
                        width: (20 / 360) * width,
                        height: (20 / 756) * height,
                        decoration: BoxDecoration(
                          color: (user.status == 'Online')
                              ? Colors.green
                              : (user.status == 'Offline' ||
                                      user.status == 'Invisible')
                                  ? Colors.grey
                                  : (user!.status == 'Busy')
                                      ? Colors.red
                                      : Colors.amber,
                          shape: BoxShape.circle,
                        ))
                    : Obx(
                        () => Container(
                            margin: EdgeInsets.only(
                              left: (20 / 360) * width,
                              right: (5 / 360) * width,
                            ),
                            width: (20 / 360) * width,
                            height: (20 / 756) * height,
                            decoration: BoxDecoration(
                              color:
                                  (userController.loggedUserStatus == 'Online')
                                      ? Colors.green
                                      : (userController.loggedUserStatus ==
                                                  'Offline' ||
                                              userController.loggedUserStatus ==
                                                  'Invisible')
                                          ? Colors.grey
                                          : (userController.loggedUserStatus ==
                                                  'Busy')
                                              ? Colors.red
                                              : Colors.amber,
                              shape: BoxShape.circle,
                            )),
                      ),
                (user != null && user.id != userController.loggedUserID)
                    ? Text(
                        user.status,
                        style: GoogleFonts.hind(
                            color: const Color.fromARGB(255, 241, 219, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: (16 / 360) * width),
                      )
                    : Container(
                        padding: EdgeInsets.only(top: (2.0 / 756) * height),
                        child: TextButton(
                          onPressed: (user != null)
                              ? null
                              : () async {
                                  await userController.changeStatus(
                                      await _dialogBuilder(context) ??
                                          userController.loggedUserStatus);
                                  log('Change status to: ${userController.loggedUserStatus}');
                                },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: (10 / 756) * height,
                              horizontal: (15 / 360) * width,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 54, 9, 91),
                            minimumSize: const Size(100, 40),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: Obx(
                            () => Text(
                              userController.loggedUserStatus,
                              style: GoogleFonts.hind(
                                  color:
                                      const Color.fromARGB(255, 241, 219, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: (16 / 360) * width),
                            ),
                          ),
                        ),
                      )
              ],
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: (20 / 360) * width,
                    top: (10 / 756) * height,
                  ),
                  child:
                      (user != null && user.id != userController.loggedUserID)
                          ? AutoSizeText(
                              user.email,
                              maxLines: 1,
                              style: GoogleFonts.hind(
                                color: Colors.white,
                                fontSize: (16 / 360) * width,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Obx(() => AutoSizeText(
                                userController.loggedUserEmail,
                                maxLines: 1,
                                style: GoogleFonts.hind(
                                  color: Colors.white,
                                  fontSize: (16 / 360) * width,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget buildAccountStats(double width, double height, {UserModel? user}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (20.0 / 360) * width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: (user != null && user.id != userController.loggedUserID)
            ? [
                buildStatColumn(
                    'Publicaciones', user.postsIDs.length, width, height,
                    user: user),
                buildStatColumn('Amigos', user.friends.length, width, height,
                    user: user),
              ]
            : [
                buildStatColumn('Publicaciones',
                    postController.userPosts.length, width, height),
                buildStatColumn('Amigos',
                    userController.loggedUserFriends.length, width, height),
              ],
      ),
    );
  }

  Widget buildStatColumn(String label, int count, double width, double height,
      {UserModel? user}) {
    return Container(
        width: width * 0.4,
        padding: EdgeInsets.only(top: 0.0132 * height),
        child: TextButton(
          onPressed: (label == 'Publicaciones')
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text(
                                    'Amigos de ${(user != null && user.id != userController.loggedUserID) ? user.username : userController.loggedUserUsername}'),
                                backgroundColor: const Color.fromARGB(
                                    255, 54, 9, 91), //Color(0xFF36095B),
                              ),
                              body: (user != null &&
                                      user.id != userController.loggedUserID)
                                  ? FriendsPage(userUUID: user.id)
                                  : const FriendsPage(),
                            )),
                  );
                },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.003, horizontal: width * 0.0138),
            backgroundColor: const Color.fromARGB(255, 54, 9, 91),
            minimumSize: const Size(150, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: Text(
            '$count\n$label',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
                color: const Color.fromARGB(255, 241, 219, 255),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.042),
          ),
        ));
  }

  Widget buildAction(double width, double height, {UserModel? user}) {
    return Padding(
      padding: EdgeInsets.only(
          top: height * 0.02, left: width * 0.11, right: width * 0.11),
      child: Center(
        child: TextButton(
          onPressed: () {
            (user != null && user.id != userController.loggedUserID)
                ? log('Add friend button pressed')
                : log('Edit Button Pressed');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: 0.01 * height, horizontal: 0.04 * width),
            backgroundColor: const Color.fromARGB(255, 54, 9, 91),
            minimumSize: const Size(200, 0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: (user != null && user.id != userController.loggedUserID)
              ? RichText(
                  text: TextSpan(children: [
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(right: 0.01 * width),
                      child: Icon(
                        Icons.person_add,
                        color: const Color.fromARGB(255, 241, 219, 255),
                        size: 0.04 * width,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Agregar a amigos',
                    style: GoogleFonts.hind(
                        color: const Color.fromARGB(255, 241, 219, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 0.04 * width),
                  ),
                ]))
              : Text(
                  'Editar Perfil',
                  style: GoogleFonts.hind(
                      color: const Color.fromARGB(255, 241, 219, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: (20 / 360) * width),
                ),
        ),
      ),
    );
  }

  Widget buildContent(double width, double height, {UserModel? user}) => Column(
        children: [
          const Divider(),
          TextButton(
              onPressed: () => {log('Plataformas')},
              child: Text('Plataformas',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.hind(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (20 / 360) * width))),
          Container(
            color: const Color.fromARGB(255, 54, 9, 91),
            width: width,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildImg('platforms_logos/xbox-logo.png', width, height),
                    buildImg(
                        'platforms_logos/PlayStation-logo.jpg', width, height),
                    buildImg('platforms_logos/pc-logo.jpg', width, height),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          TextButton(
              onPressed: () => {log('Juegos')},
              child: Text('Juegos',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.hind(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (20 / 360) * width))),
          Container(
            color: const Color.fromARGB(255, 54, 9, 91),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                    // ListView.builder(
                    //   itemCount: games,
                    //   itemBuilder: (context, index) {
                    //     return buildImg(
                    //         'platforms_logos/pc-logo.jpg', width, height);
                    //   },
                    // ),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildImg('games_icons/valorant_icon.png', width, height),
                    buildImg(
                        'games_icons/rocket_league_icon.png', width, height),
                    buildImg('games_icons/fall_guys_icon.png', width, height),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget buildImg(String img, double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (8.0 / 360) * width),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FutureBuilder(
          future: storage.downloadURL(img),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
                width: (100 / 360) * width,
                height: (150 / 756) * height,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<String?> _dialogBuilder(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        return SimpleDialog(
          title: const Text(
            'Cambiar estado.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 64, 32, 104),
          elevation: 24,
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Online');
              },
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 0.00555),
                      child: Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: width * 0.0444,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Online',
                    style: GoogleFonts.hind(
                      color: Colors.white,
                      fontSize: width * 0.0444,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Invisible');
              },
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 0.00555),
                      child: Icon(
                        Icons.circle_outlined,
                        color: Colors.grey,
                        size: width * 0.0444,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Invisible',
                    style: GoogleFonts.hind(
                      color: Colors.white,
                      fontSize: width * 0.0444,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Busy');
              },
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 0.00555),
                      child: Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: width * 0.0444,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Busy',
                    style: GoogleFonts.hind(
                      color: Colors.white,
                      fontSize: width * 0.0444,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Away');
              },
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 0.00555),
                      child: Icon(
                        Icons.circle,
                        color: Colors.amber,
                        size: width * 0.0444,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Away',
                    style: GoogleFonts.hind(
                      color: Colors.white,
                      fontSize: width * 0.0444,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
